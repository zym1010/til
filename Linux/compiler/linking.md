# Linking

August 29, 2016  
Yimeng Zhang

This article clarifies some confusions on how a linker works, especially when shared libraries are used.

## `project`

The directory to `project` in the folder containing this post is a minialist example about shared library linking. Original `project.zip` (`project-original.zip`) comes from [this so post][9] (direct link <http://dl.dropbox.com/u/31990648/SourceForge/rpath_origin_recursive/project.zip>) All tests were done in a Ubuntu 14.04 machine with GCC 4.8.4. 

This is a good example showing how to build an executable with secondary dependencies.

`main` depends on `libfoo`, which depends on `libbar`.

first, change directory to `project` and then run the following

1. `./make-correct.sh` probably best practice, all library resolution done via relative link.
2. `./make-search-dependency-rpath.sh` the resulution of `bar` for `foo` is done through `RPATH` without `$ORIGIN`, and this can be used by `ld` when linking `main`. But this is not portable.
3. `./make-search-dependency-rpath-fail.sh` showing that `$ORIGIN` can't be understood by `ld`. Thus building failed.

## Big picture

For C/C++, according to textbooks and many other sources, the compiler first compiles each `.c/.cpp` files separately, getting object files `.o`. Then linker (in the case of GCC, `ld`) links all of them together, **plus** some additional system-wide libraries, such as `libc` implicitly, generating a final binary in a format called ELF.

### Link order

[The answer given by ANT on stackoverflow][2] explains this very well. Libraries providing definitions of functions invoked in your files should appear later in compile commands, also, not all of code in libraries will be copied. Only those needed will be. And this post also explains how to resolves circular dependencies between libraries, either by overlinking or using a special syntax. (I think some people on stackoverflow said overlinking is more common and has no problem in practice).

### Static vs. shared

From the perspective of linker, there are two types of files to consider.

1. static. This is the case for `.o` files generated from `.c/.cpp` files you write yourself, and those `.a` libraries, which is just a bunch of `.o` files, according to [An Introduction to GCC: For the GNU Compilers GCC and G++][1] (Check top of 10.1 Creating a library with the GNU archiver). So these two are essentially the same.
	* It's not the case that a static library does not need any more dependencies. Just like ordinary `.o` files may have unresolved dependencies, so can some static libraries. However, publishing a static library that requires some additional linking is not good style, I think. 
	* My previous point is confirmed by [this blog post][3], which says
	  
	  > Trying to link only with libbar.a produces an error, since it has an undefined symbol and the linker has no clue where to find it:
	  >
	  > To summarize, when linking an executable against a static library, **you need to specify explicitly all dependencies towards shared libraries introduced by the static library on the link command**.
	  >
	  > Note however that expressing, discovering and adding implicit static libraries dependencies is typically a feature of your build system (autotools, cmake).
2. dynamic. This is the case for `.so` files, which can be generated via options like `-fPIC` and `-shared` (see [this blog post][3]). There are some subtlties in terms of naming of `.so` files, such as aliasing, soname, etc., explained somehow in [this blog post][3]. But the general idea of dynamic files is that in the final executable, the code in the libraries is NOT copied into it, only a stub instructing the operating system to load the dynamic library in the runtime is written in the exectutable, and that is the **only link** between the exectuable and the `.so` files.

### Link between exectuable (or `.so`) and the `.so` files

The crucial thing is, how can executable (or `.so`) load the correct `.so`, which will potentially load more `.so` files in the runtime? You can do `readelf -d FILENAME` to show the link between exectuable (or `.so`) with name `FILENAME` and the `.so` files it needs.

An example can be produced when `readelf -d lib/dir/libfoo.so`, after switching the directory to `project` in the folder containing this post.

~~~
leelab_share@leelabgpu:~/project$ readelf -d lib/dir/libfoo.so

Dynamic section at offset 0xe28 contains 23 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libbar.so]
 0x000000000000000e (SONAME)             Library soname: [libfoo.so]
 0x000000000000000f (RPATH)              Library rpath: [/home/leelab_share/project/lib/dir/sub]
~~~

Seems that `Type` and `Name/Value` are most important and understandble. A tag with type `NEEDED` have the name of needed shared library, and `SONAME` is the soname of `FILENAME`, and this `SONAME` is useful when this file is used as a shared library. `RPATH` is a place (or multiple, separated by `:`, just as in `PATH`) to find those `NEEDED` files. This rpath can be either absolute, or with a special token `$ORIGIN` in it, and `$ORIGIN` will refer to the directory containing this `FILENAME` file. Actually, this `RPATH` is not the only place searching will happen. This will be explained later.

## How dynamic libraries are found in the runtime.

When executing a program, I guess its `NEEDED` libraries are loaded one by one, and their `NEEDED` libraries are also loaded, in some breadth first manner, as said in [this SO post][5]. It can be confirmed via multiple ways, either by reading the ELF format yourself <http://refspecs.linuxbase.org/elf/elf.pdf> or using external tools like `ldd` as shown in the previous SO post.

What happens when a new `.so` file is encountered (either directly or indirectly needed by a program) [This article from Debian wiki][4] explains very well what happens 

1. the DT_RPATH dynamic section attribute of the library causing the lookup
2. the DT_RPATH dynamic section attribute of the executable
3. the LD_LIBRARY_PATH environment variable, unless the executable is setuid/setgid.
4. the DT_RUNPATH dynamic section attribute of the executable
5. /etc/ld.so.cache
6. base library directories (/lib and /usr/lib)

`DT_RPATH` is just `RPATH` extracted by `readelf -d`. `DT_RUNPATH` is probably never used, although some places argue this is better than `DT_RPATH` (see [readme of `ld.so`][6], they say `Use of DT_RPATH is deprecated.`). In practice, three places are checked.

1. `RPATH`. set at built time of the library causing lookup
2. `RPATH`. set at built time of the executable.
2. `LD_LIBRARY_PATH`. set at runtime.
3. default locations, such `/etc/ld.so.cache` and `base library directories`, maybe also `/etc/ld.so`. In any case, people should not change these.

I think there are maybe some other places to define these, but I think the previous four places are the main place to go.

The most important thing about this order is that when there is a secondary (indirectly dependent) library to be found, the `RPATH` in the primary (directly dependent) library will be searched before the `RPATH` of the main executable. Also notice that `$ORIGIN` in `RPATH` is w.r.t. each `.so` file, so `$ORIGIN` always means the parent directory of a file, no matter that file is run as an executable itself, or used as a library. This means that when designing the `RPATH` of a file, we only need to care about its direct dependencies, assuming that `RPATH` of direct dependencies are well written, so we don't need additionally specify `RPATH` to find them.

## How dynamic libraries are found in the compile time.

During compilation, indirect (dynamic) dependencies will be implicitly found by linker `ld`. According to [readme of `ld`][7], the following places are tried.

1. `-rpath-link` options passed into `ld`
2. `-rpath` options passed into `ld`
3. `LD_RUN_PATH`
4. `LD_LIBRARY_PATH`
5. `RPATH` or `RUNPATH` of a shared library dependency. I have no idea the order of search for `RPATH` of different library dependencies. Maybe they form some breadth first search or not. But in any case, this should not affect the result of compilation, that is, if there are multiple secondary shared libraries to be found, they should be the same. Otherwise, I would consider the program to be too fragile.
6. The default directories, normally /lib and /usr/lib.
7. `/etc/ld.so.conf`

`LD_RUN_PATH` can be skipped, as it can be configured using `-rpath`. `LD_LIBRARY_PATH` can also be skipped, using `-rpath-link`. So roughly speaking we have

1. `-rpath-link` options passed into `ld`
2. `-rpath` options passed into `ld`
3. `RPATH` or `RUNPATH` of a shared library dependency.
4. default locations.

Notice that 

1. `-rpath-link` is like setting one additional `RPATH` entry in the front of (probably existing) `RPATH` entry for each library, but it's not going to persist in the built executable.
2. `-rpath` is similar to `-rpath-link`, but `RPATH` entry of the built executable will be written with its value.
3. In all cases, `$ORIGIN` is NOT understood as is. I guess either it expands to empty string, or, more likely, the literal `$ORIGIN` is used to match some directory name. Well there can be some confusion and I don't think it's good to have a directory named `$ORIGIN` anyway. **THIS IS BIGGEST difference between `ld` and `ld.so`**  [This post][8] also confirms this.



## Best practice

This is just advice for building those `conda` programs, where you want location independence.

Put simply, specify `-rpath` with `$ORIGIN` in it, and all needed `-rpathlink` (probably same as `-rpath`) with NO `$ORIGIN` in it.

since `ld` will not expand `$ORIGIN` AT ALL, `rpath-link` should be contain no `$ORIGIN`. Therefore, `rpath` with `$ORIGIN` is not be actually used during linking. To make sure everything works, specify `-rpath` with `$ORIGIN` in it, and specify the same location for `-rpath-link`, but without `$ORIGIN` How to get the current directory, which would be useful for `rpath-link`? Try <http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in?page=1&tab=votes#tab-top>, that is `DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"`.

## How to check dependency related stuff.

* `objdump -x XXX | grep RPATH` should give you RPATH
* `ldd XXX` should give you list of so files needed by the executable (all dependencies)
* `readelf -d XXX` can be used to get the RPATH and direct dependencies as well.

## Random things.

When specifying linker options such as `-rpath` through `gcc` or `g++`, we need to use format `Wl,-rpath,XXX`, and this will traslate to `-rpath XXX` to linker. If `XXX` contains `$ORIGIN`, we should quote it in single quote to avoid expansion.

Also, direct dependences are not found by `-rpath`. Instead they should be specified through `-L`.

I think the reason is that maybe only the library loader at runtime (`ld.so` knows `$ORIGIN`), but not `ld` (compiler time linker). See <http://linux.die.net/man/8/ld-linux>, and notice that there's no much relevant mention of `$ORIGIN` in <http://linux.die.net/man/1/ld> (only thing I found is `-z origin`, which seems to add a `FLAGS_1` tag with value `Flags: ORIGIN` when using `readelf -d`).

Why can't we link to some home-installed libc very easily? Because libc is not just `libc.so`. Programs such as `ld.so`, which handles loading of dynamic libraries are also part of it, and all these components must be of the same version. That means to change libc, you have to change many many files, which are very prone to error and not easy to do in a clean way. Check <http://stackoverflow.com/questions/19709932/segfault-from-ld-linux-in-my-build-of-glibc> or <http://unix.stackexchange.com/questions/272606/locally-installing-glibc-2-23-causes-all-programs-to-segfault>, or any article talking about segmentation fault when using some alternative libc.

adding more `-lxxx` in your command line may make the compiling command redundant, but will not affect size of resultant binary. Check <http://stackoverflow.com/questions/370549/size-of-a-library-and-the-executable>. Basically, only useful parts of the library will get linked.

## Which is preferred when having both

If both `libXXX.a` and `libXXX.so` are available, `.so` one will be preferred, unles `-static` is passed to force static linking. This is from [An Introduction to GCC: For the GNU Compilers GCC and G++][1]. See page 


[1]: http://www.linuxtopia.org/online_books/an_introduction_to_gcc/
[2]: http://stackoverflow.com/questions/11893996/why-does-the-order-of-l-option-in-gcc-matter
[3]: http://www.kaizou.org/2015/01/linux-libraries/
[4]: https://wiki.debian.org/RpathIssue
[5]: http://stackoverflow.com/questions/3616453/in-what-order-does-ld-linux-so-search-shared-libraries
[6]: http://linux.die.net/man/8/ld.so
[7]: http://linux.die.net/man/1/ld
[8]: <http://stackoverflow.com/questions/11316016/gnu-ld-does-not-handle-origin-processing-correctly-is-there-a-workaround>
[9]: <http://stackoverflow.com/questions/6323603/ld-using-rpath-origin-inside-a-shared-library-recursive>
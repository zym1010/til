## Rsync

This document gives some of my tips about `rsync`.

### Append `/` after the destination.

This is crucial when 1) you are only copying a single file 2) you are not sure whether the destination folder exists or not. Basically, when you use cp, you face the same ambiguity (well at least some mental burden). Check example in <http://stackoverflow.com/questions/18491548/rsync-create-all-missing-parent-directories>. 

When doing `rsync /top/a/b/c/d remote:/top/a/b/c`, if `remote:/top/a/b` already exists, but `c` does not, then this command will copy `d` to be `/top/a/b/c`, not `/top/a/b/c/d`. But this is not the case if you use `/top/a/b/c/`.

I discovered this when writing DataSMART. See <https://github.com/leelabcnbc/datasmart/blob/20d044b9c27bffcf1812535d4fc7ff1f6cedf2eb/datasmart/core/filetransfer.py#L389-L407>.

### How to copy a folder structure only.

This is useful when I want to maintain some supplemental files for my iTunes library. Basically, I created another folder having same folder structure as my iTunes Library, but without any file.

`rsync -av --include='*/' --exclude='*' /path/to/src /path/to/dest/`

I don't care in detail how `--include` and `--exclude` interact, but basically here it just works, including directories, but excluding all others. Based on <http://stackoverflow.com/questions/19296190/rsync-include-from-vs-exclude-from-what-is-the-actual-difference>, the first matching pattern is used.

To create exactly the same structure of `/lib1` as in `lib2`, we should use

`rsync -av --include='*/' --exclude='*' /lib1/ /lib2/`

Notice the trailing slashes.

### Some subtleties in `--files-from`

`--files-from=XXX` is used in my DataSMART, and while in general each line in XXX is a filename, in practice it's a little subtle. For example, if your filename starts with `;`, then that file will get ignored, because it's somehow considered as comment. See <http://samba.2283325.n4.nabble.com/comments-with-in-files-from-td2510187.html>.

The solution is always prepending your file names with `/`. See <https://github.com/leelabcnbc/datasmart/blob/20d044b9c27bffcf1812535d4fc7ff1f6cedf2eb/datasmart/core/filetransfer.py#L329-L331> for some example.

### `--iconv` depends on libraries on both sides.

Sometime you may want to convert filename encoding when doing rsync between two computers. I think it's best to stick to ASCII naming to avoid this. But if you really need it, say using `--iconv==a,b`, that is, converting filenames in encoding `a` on source computer to filenames in encoding `b` on target computer. You should know that `--iconv==b,a` may not work. Basically, source computer is responsible to understand encoding `a` but not `b`, and vice versa for destination computer.

I think the under-the-hood mechanism is that, the source computer first converts filenames in encoding `a` to some common format, say `utf8`, and then get transferred to destination computer, which then converts filenames to be in encoding `b`, using related library (I think called `libiconv`; same for source computer). Imporant thing is that `libiconv` on source doesn't need to understand `b`, and that on destination doesn't need to understand `a`.

This is what happends in <http://serverfault.com/questions/638316/rsync-iconv-option-on-mac-not-working-sync-from-remote-linux-server-to-local>. The complexity of this issue caused me to drop support for non ASCII characters in filename completely, as I don't know how to do it correctly.

The reason we need these conversion, might be that actually Linux filesystem doesn't care about filename encoding, and filename is just a bunch of bytes from the view point of file system.

If you really need to copy files between two file systems with different encodings, follow suggestions in <http://serverfault.com/questions/397420/converting-utf-8-nfd-filenames-to-utf-8-nfc-in-either-rsync-or-afpd>, and let the volume sharing protocol handle that for you.
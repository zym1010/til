DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo Create directories.
mkdir -p -v obj
mkdir -p -v lib/dir/sub
mkdir -p -v run

echo Build bar.so:
g++ -c -o obj/bar.o src/bar.cpp -fPIC
g++ -shared -o lib/dir/sub/libbar.so obj/bar.o -Wl,-soname,libbar.so

echo Build foo.so:
g++ -c -o obj/foo.o src/foo.cpp -fPIC
# here, rpath is for finding libbar at runtime. at compile time, it's found through -L.
g++ -shared -o lib/dir/libfoo.so obj/foo.o -Wl,-soname,libfoo.so -Wl,-rpath,"${DIR}/lib/dir/sub" -Llib/dir/sub -lbar

### Alternate foo that doesn't link to bar:
#g++ -c -o obj/foo2.o src/foo2.cpp -fPIC
#g++ -shared -o lib/dir/foo.so obj/foo2.o -Wl,-soname,foo.so

echo Build main.run:
g++ -c -o obj/main.o src/main.cpp
# since rpath for libfoo can be understood by ld, rpath link will not be needed.
g++ -o run/main.run obj/main.o  -Llib/dir -lfoo -Wl,-rpath,'$ORIGIN/../lib/dir'
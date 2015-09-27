# LOLOS

A toy OS. Currenly more or less taken from http://wiki.osdev.org/Bare_Bones.

## GCC Cross Compiler

See http://wiki.osdev.org/GCC_Cross-Compiler for more information.

Download and unpack the prerequisites:

    $ curl http://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.gz > binutils-2.25.1.tar.gz
    $ tar -xvzf binutils-2.25.1.tar.gz
    $ curl http://www.netgull.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz > gcc-5.2.0.tar.gz
    $ tar -xvzf gcc-5.2.0.tar.gz
    $ curl https://gmplib.org/download/gmp/gmp-6.0.0a.tar.lz > gmp-6.0.0a.tar.lz
    $ lzip -d -k gmp-6.0.0a.tar.lz
    $ tar -xvf gmp-6.0.0a.tar
    $ curl http://www.mpfr.org/mpfr-current/mpfr-3.1.3.tar.gz > mpfr-3.1.3.tar.gz
    $ tar -xvzf mpfr-3.1.3.tar.gz
    $ curl http://isl.gforge.inria.fr/isl-0.14.tar.gz > isl-0.14.tar.gz
    $ tar -xvzf isl-0.15.tar.gz
    $ curl http://www.bastoul.net/cloog/pages/download/cloog-0.18.4.tar.gz > cloog-0.18.4.tar.gz
    $ tar -xvzf cloog-0.18.4.tar.gz
    $ curl ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz > mpc-1.0.3.tar.gz
    $ tar -xvzf mpc-1.0.3.tar.gz
    $ curl http://ftp.gnu.org/gnu/texinfo/texinfo-6.0.tar.gz > texinfo-6.0.tar.gz
    $ tar -xvzf texinfo-6.0.tar.gz
    $ curl http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz > libiconv-1.14.tar.gz
    $ tar -xvzf libiconv-1.14.tar.gz

Set up the environment for building:

    $ export PREFIX="$HOME/opt/gcc-5.2.0"
    $ export TARGET=i686-elf
    $ export PATH="$PREFIX/bin:$PATH"

Build binutils:

    $ cp -r isl-0.15 binutils-2.25.1/isl
    $ cp -r cloog-0.18.4 binutils-2.25.1/cloog
    $ mkdir build-binutils
    $ cd build-binutils
    $ ../binutils-2.25.1/configure --prefix="$PREFIX" --disable-nls --disable-werror
    $ make
    $ make install

Check to make sure binutils was built correctly:

    $ which -- $TARGET-as || echo $TARGET-as is not in the PATH

Builg GCC:

    $ cp -r libiconv-1.14 gcc-5.2.0/libiconv
    $ cp -r gmp-6.0.0 gcc-5.2.0/gmp
    $ cp -r mpfr-3.1.3 gcc-5.2.0/mpfr
    $ cp -r mpc-1.0.3 gcc-5.2.0/mpc
    $ cp -r isl-0.15 gcc-5.2.0/isl
    $ cp -r cloog-0.18.4 gcc-5.2.0/cloog
    $ mkdir build-gcc
    $ cd build-gcc
    $ ../gcc-5.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    $ make all-gcc
    $ make all-target-libgcc
    $ make install-gcc
    $ make install-target-libgcc

Check to make sure GCC was built correctly:

    $ which -- $TARGET-gcc || echo $TARGET-gcc is not in the PATH

## Building the Kernel

    $ cd src
    $ make all

## Making a Bootable Disc

If on OSX:

    $ vagrant up
    $ vagrant ssh
    $ cd src
    $ grub-mkrescue -o os.iso iso

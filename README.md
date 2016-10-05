# LOLOS

A toy OS. Currenly more or less taken from the [OSDev.org Bare Bones](http://wiki.osdev.org/Bare_Bones) instructions.

## GCC Cross Compiler

See the [OSDev.org GCC Cross-Compiler](http://wiki.osdev.org/GCC_Cross-Compiler) instructions for more detailed information.

1. Make a directory for the compiler source code:

        $ mkdir compiler-src
        $ cd compiler-src

2. Download and unpack the prerequisites:

        $ curl http://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.gz > binutils-2.25.1.tar.gz
        $ tar -xvzf binutils-2.25.1.tar.gz
        $ curl http://www.netgull.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz > gcc-5.2.0.tar.gz
        $ tar -xvzf gcc-5.2.0.tar.gz
        $ curl https://gmplib.org/download/gmp/gmp-6.0.0a.tar.lz > gmp-6.0.0a.tar.lz
        $ lzip -d -k gmp-6.0.0a.tar.lz
        $ tar -xvf gmp-6.0.0a.tar
        $ curl http://www.mpfr.org/mpfr-3.1.3/mpfr-3.1.3.tar.gz > mpfr-3.1.3.tar.gz
        $ tar -xvzf mpfr-3.1.3.tar.gz
        $ curl http://isl.gforge.inria.fr/isl-0.14.tar.gz > isl-0.14.tar.gz
        $ tar -xvzf isl-0.14.tar.gz
        $ curl http://www.bastoul.net/cloog/pages/download/cloog-0.18.4.tar.gz > cloog-0.18.4.tar.gz
        $ tar -xvzf cloog-0.18.4.tar.gz
        $ curl ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz > mpc-1.0.3.tar.gz
        $ tar -xvzf mpc-1.0.3.tar.gz
        $ curl http://ftp.gnu.org/gnu/texinfo/texinfo-6.0.tar.gz > texinfo-6.0.tar.gz
        $ tar -xvzf texinfo-6.0.tar.gz
        $ curl http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz > libiconv-1.14.tar.gz
        $ tar -xvzf libiconv-1.14.tar.gz

3. Make a directory for building.

        $ cd ..
        $ mkdir compiler-build

4. Set environment variables for building:

        $ export PREFIX="$HOME/opt/cross"
        $ export TARGET=i686-elf
        $ export PATH="$PREFIX/bin:$PATH"

4. Build binutils:

        $ cd compiler-src
        $ cp -r isl-0.14 binutils-2.25.1/isl
        $ cp -r cloog-0.18.4 binutils-2.25.1/cloog
        $ cd ../compiler-build
        $ mkdir binutils
        $ cd binutils
        $ ../../compiler-src/binutils-2.25.1/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-werror --enable-interwork --enable-multilib
        $ make
        $ make install

5. Check to make sure binutils was built correctly:

        $ which -- $TARGET-as || echo $TARGET-as is not in the PATH

6. Builg GCC:

        $ cd ../../compiler-src
        $ cp -r libiconv-1.14 gcc-5.2.0/libiconv
        $ cp -r gmp-6.0.0 gcc-5.2.0/gmp
        $ cp -r mpfr-3.1.3 gcc-5.2.0/mpfr
        $ cp -r mpc-1.0.3 gcc-5.2.0/mpc
        $ cp -r isl-0.14 gcc-5.2.0/isl
        $ cp -r cloog-0.18.4 gcc-5.2.0/cloog
        $ cd ../compiler-build
        $ mkdir gcc
        $ cd gcc
        $ ../../compiler-src/gcc-5.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
        $ make all-gcc
        $ make all-target-libgcc
        $ make install-gcc
        $ make install-target-libgcc

7. Check to make sure GCC was built correctly:

        $ which -- $TARGET-gcc || echo $TARGET-gcc is not in the PATH

## Building the Kernel

    $ cd src
    $ make all

## Making a Bootable Disc

### On OSX

First download and install [Vagrant](https://www.vagrantup.com/downloads.html).

    $ vagrant up
    $ vagrant ssh
    $ sudo apt-get install xorriso
    $ cd src
    $ grub-mkrescue -o os.iso iso

## Booting

1. Create a VM with a few MB of memory.
2. Set the optical drive storage to point to the ISO file.
3. Set the boot order so the optical disk is first.
4. Start the VM and then select "\*os" in the GRUB boot menu.

## Helpful Links

* [GNU Binutils](https://www.gnu.org/software/binutils/)
* [GCC, the GNU Compiler Collection](https://www.gnu.org/software/gcc/)
* [The GNU Multiple Precision Arithmetic Library](https://gmplib.org/)
* [The GNU MPFR Library](http://www.mpfr.org/)
* [Integer Set Library](http://isl.gforge.inria.fr/)
* [CLooG](http://www.cloog.org/)
* [GNU MPC](http://multiprecision.org/)
* [Texinfo - The GNU Documentation System](https://www.gnu.org/software/texinfo/)
* [How to Build a GCC Cross-Compiler](http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/)

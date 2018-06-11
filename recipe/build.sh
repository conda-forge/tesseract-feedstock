#!/usr/bin/env bash

pushd tesseract

autoreconf -fi
LIBLEPT_HEADERSDIR=$PREFIX/include ./configure --prefix=$PREFIX --with-extra-libraries=$PREFIX/lib
LDFLAGS="-L$PREFIX/lib" CFLAGS="-I$PREFIX/include" make -j $CPU_COUNT
make install
popd

pushd tessdata
cp -avf * $PREFIX/share/tessdata

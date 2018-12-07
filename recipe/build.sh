#!/bin/bash

pushd tesseract

autoreconf -vi
./autogen.sh
mkdir build && cd build
../configure --prefix="${PREFIX}"
make -j $CPU_COUNT
make install
popd

pushd tessdata
cp -avf * $PREFIX/share/tessdata
popd

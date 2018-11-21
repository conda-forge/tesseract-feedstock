#!/usr/bin/env bash

pushd tesseract

autoreconf -fi
LIBLEPT_HEADERSDIR="${PREFIX}/include" ./configure --prefix="${PREFIX}" --with-extra-libraries="${PREFIX}/lib"
make -j $CPU_COUNT CC="${CC}" CXX="${CXX}"
make install
popd

pushd tessdata
cp -avf * $PREFIX/share/tessdata

#!/usr/bin/env bash

pushd tesseract

autoreconf -fi
LIBLEPT_HEADERSDIR="${PREFIX}/include" ./configure \
    --prefix="${PREFIX}" \
    --with-extra-libraries="${PREFIX}/lib" \
    CC="${CC}" \
    CXX="${CXX}" \
    || { cat config.log; exit 1; }
make -j $CPU_COUNT
make install
popd

pushd tessdata
cp -avf * $PREFIX/share/tessdata

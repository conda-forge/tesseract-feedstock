#!/bin/bash

pushd tesseract

autoreconf -vi
./autogen.sh
mkdir build && cd build
../configure --prefix="${PREFIX}"
make -j $CPU_COUNT
make install
popd

pushd tessdata_fast
cp -avf *.traineddata $PREFIX/share/tessdata
popd

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
    cp "${RECIPE_DIR}/${CHANGE}.ps1" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.ps1"
done

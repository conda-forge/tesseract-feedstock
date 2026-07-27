#!/bin/bash

pushd tesseract

autoreconf -vi
./autogen.sh
mkdir build && cd build

# See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
if [[ "${target_platform}" == "osx-64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

../configure --prefix="${PREFIX}"
make -j $CPU_COUNT
make install
popd

pushd tessdata_fast
cp -avf *.traineddata $PREFIX/share/tessdata
popd

# Set TESSDATA_PREFIX via env_vars.d JSON (handled by conda at activation time).
mkdir -p "${PREFIX}/etc/conda/env_vars.d"
printf '{"TESSDATA_PREFIX": "%s/share/tessdata/"}\n' "${PREFIX}" > "${PREFIX}/etc/conda/env_vars.d/${PKG_NAME}.json"
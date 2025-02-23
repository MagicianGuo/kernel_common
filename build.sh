#!/bin/bash

set -e

LTO=thin

TARGET_DEFCONFIG=${1:-gki_defconfig}

cd "$(dirname "$0")"

LOCALVERSION=-android13

ARGS="
CC=clang
ARCH=arm64
LLVM=1 LLVM_IAS=1
LOCALVERSION=$LOCALVERSION
"

# build kernel
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} $TARGET_DEFCONFIG

if [ "$LTO" = "thin" ]; then
  ./scripts/config --file out/.config -e LTO_CLANG_THIN -d LTO_CLANG_FULL
fi

make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS}
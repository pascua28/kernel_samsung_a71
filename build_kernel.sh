#!/bin/sh

sudo apt-get install curl wget -y

wget -O llvm.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main-kernel-2025/clang-r547379.tar.gz
mkdir llvm-20; cd llvm-20
tar xvzf ../llvm.tar.gz
rm ../llvm.tar.gz
cd ../

export ARCH=arm64
mkdir out

export PATH=llvm-20/bin:$PATH

KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"
BUILD_VAR="-j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1"

cat arch/arm64/configs/sdmmagpie_defconfig arch/arm64/configs/a71.config > arch/arm64/configs/temp_defconfig
make $BUILD_VAR temp_defconfig
rm arch/arm64/configs/temp_defconfig

make $BUILD_VAR
make $BUILD_VAR dtbs

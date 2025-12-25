#!/bin/sh

ls -l
ls -l arch/arm64/configs

wget -O llvm.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main-kernel-2025/clang-r547379.tar.gz
mkdir llvm-20; cd llvm-20
tar xvzf ../llvm.tar.gz
rm ../llvm.tar.gz
cd ../

export ARCH=arm64
mkdir out

export PATH=$(pwd)/llvm-20/bin:$PATH

KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"
BUILD_VAR="-j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1"

cat arch/arm64/configs/sdmmagpie_defconfig arch/arm64/configs/a71.config > arch/arm64/configs/temp_defconfig

echo "
CONFIG_THINLTO=y
# CONFIG_LTO_NONE is not set
CONFIG_LTO_CLANG=y
" >> arch/arm64/configs/temp_defconfig

make $BUILD_VAR temp_defconfig
rm arch/arm64/configs/temp_defconfig

make $BUILD_VAR
make $BUILD_VAR dtbs

DTBO_FILES=$(find $(pwd)/out/arch/arm64/boot/dts/samsung/ -name sm*150-sec-$DEVICE-eur-overlay-*.dtbo)
$(pwd)/tools/mkdtimg create $(pwd)/out/dtbo.img --page_size=4096 ${DTBO_FILES}

mv $(pwd)/out/dtbo.img ../dtbo.img

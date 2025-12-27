#/bin/sh

MKBOOTIMG="$(pwd)/mkbootimg/mkbootimg.py"
OUT_KERNEL="$(pwd)/kernel/out/arch/arm64/boot/Image"
RAMDISK="$(pwd)/boot/ramdisk"
MONTH="$(date +%Y-%m)"

$MKBOOTIMG \
    --header_version 2 \
    --kernel "$OUT_KERNEL" \
    --output boot.img \
    --ramdisk "$RAMDISK" \
    --os_version 16.0.0 \
    --os_patch_level "$MONTH"


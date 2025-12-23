#/bin/sh

sudo apt-get install curl wget -y

APK_URL="$(curl -s "https://api.github.com/repos/topjohnwu/Magisk/releases/latest" | grep -oE 'https://[^\"]+\.apk' | grep app-debug)"
wget -O "magisk.zip" "$APK_URL"
mkdir magiskboot
unzip "magisk.zip" "magiskboot/libmagiskboot.so"
sudo cp "magiskboot/libmagiskboot.so" "/usr/bin/magiskboot"
sudo chmod +x "/usr/bin/magiskboot"

mkdir bootimg && cd bootimg
magiskboot unpack ../boot.img
cp ../kernel/out/arch/arm64/boot/Image kernel
magiskboot repack ../boot.img boot-new.img
mv boot-new.img ../boot.img
cd ../


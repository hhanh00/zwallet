#!/bin/sh

ROOT_DIR=$1

mkdir -p $ROOT_DIR/Android/sdk
export ANDROID_SDK_ROOT=$ROOT_DIR/Android/sdk
pacman -Sy --noconfirm unzip jdk8-openjdk git

curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
unzip sdk-tools.zip
(cd cmdline-tools/bin &&
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses &&
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-31" &&
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;21.4.7075529")
rm sdk-tools.zip

pacman -Sy --noconfirm rustup
rustup install stable
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
cargo install --force cargo-make

curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.3-stable.tar.xz
tar xvf flutter.tar.xz
rm -f flutter.tar.xz

curl -sSL https://git.io/get-mo -o /usr/bin/mo
chmod +x /usr/bin/mo

mkdir /root/.zcash-params
curl https://download.z.cash/downloads/sapling-output.params -o /root/.zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params -o /root/.zcash-params/sapling-spend.params

export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/21.4.7075529
export PATH=$PATH:/flutter/bin

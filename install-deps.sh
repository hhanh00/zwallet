#!/bin/sh

ROOT_DIR=$1
if [ "$ROOT_DIR" == "" ]; then
  ROOT_DIR="/root"
fi

pacman -Sy --noconfirm unzip jdk8-openjdk wget

wget -P /tmp -N https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
wget -P /tmp -N https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip
wget -P /tmp -N https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.1-stable.tar.xz

wget -P /tmp -N https://download.z.cash/downloads/sapling-output.params
wget -P /tmp -N https://download.z.cash/downloads/sapling-spend.params

mkdir -p $ROOT_DIR/Android/sdk
export ANDROID_SDK_ROOT=$ROOT_DIR/Android/sdk

(cd $ROOT_DIR;unzip -o /tmp/commandlinetools-linux-7583922_latest.zip;
cd cmdline-tools/bin &&
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses &&
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-31")

(cd $ANDROID_SDK_ROOT;unzip -o /tmp/android-ndk-r21e-linux-x86_64.zip)
(cd $ROOT_DIR;tar xvf /tmp/flutter_linux_3.0.1-stable.tar.xz)

mkdir -p $HOME/.zcash-params
cp /tmp/sapling-output.params /tmp/sapling-spend.params $HOME/.zcash-params

export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/android-ndk-r21e
export PATH=$PATH:$ROOT_DIR/flutter/bin

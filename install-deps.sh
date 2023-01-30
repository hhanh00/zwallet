#!/bin/sh
set -x

FLUTTER_VERSION=3.7.0

ROOT_DIR=$1
if [ "$ROOT_DIR" == "" ]; then
  ROOT_DIR="/root"
fi

DL_DIR=$2
if [ "$DL_DIR" == "" ]; then
  DL_DIR="/tmp"
fi

sudo pacman -Sy --noconfirm unzip jdk11-openjdk

mkdir $HOME/.zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output $HOME/.zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output $HOME/.zcash-params/sapling-spend.params

export ANDROID_HOME=$ROOT_DIR/Android/sdk
mkdir -p $ANDROID_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME

pushd $ROOT_DIR
curl https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip --output $DL_DIR/cmd-tools.zip
unzip -o $DL_DIR/cmd-tools.zip
cd cmdline-tools/bin
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "cmdline-tools;latest"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;30.0.3" "cmake;3.18.1"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;25.1.8937393"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-33"
rm $DL_DIR/cmd-tools.zip
popd

curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz --output $DL_DIR/flutter.tar.xz
tar x -C $ROOT_DIR -f $DL_DIR/flutter.tar.xz
rm $DL_DIR/flutter.tar.xz

export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.1.8937393
export PATH=$PATH:$ROOT_DIR/flutter/bin


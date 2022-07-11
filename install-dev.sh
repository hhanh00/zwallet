#sudo pacman -Sy --noconfirm base-devel cmake rustup unzip wget jdk8-openjdk
#./install-rust.sh
#./install-deps.sh $HOME

#export ANDROID_SDK_ROOT=$HOME/Android/sdk
#export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/android-ndk-r21e
#export PATH=$HOME/flutter/bin:$PATH

#cp docker/zwallet-sample.jks docker/zwallet.jks
#export JKS_PASSWORD=zwallet

#./configure.sh
./build.sh

sudo apt-get update
sudo apt-get -y install build-essential unzip default-jre cmake

cd $HOME

mkdir .zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output .zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output .zcash-params/sapling-spend.params
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ".cargo/env"
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
cargo install --force cargo-make cargo-ndk

curl https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip --output cmd-tools.zip
mkdir Android
export ANDROID_SDK_ROOT=$HOME/Android/sdk
unzip cmd-tools.zip
pushd cmdline-tools/bin
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "cmdline-tools;latest"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;30.0.3" "cmake;3.18.1"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;25.1.8937393"
yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-33"
popd
rm cmd-tools.zip

curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.10-stable.tar.xz --output flutter.tar.xz
tar xf flutter.tar.xz
rm flutter.tar.xz

export PATH=$PATH:$HOME/flutter/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
git config --global --add safe.directory $HOME/flutter

pushd $1
cp docker/zwallet-sample.jks docker/zwallet.jks
export JKS_PASSWORD=zwallet
./configure.sh
./build.sh
popd

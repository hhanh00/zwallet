set -x
export BUILD_DIR=$PWD
pushd $HOME


if [ -z "$GITHUB_ACTIONS" ]
then
    mkdir -p Android/sdk
    curl https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip --output cmd-tools.zip
    unzip cmd-tools.zip
    pushd cmdline-tools/bin
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "cmdline-tools;latest"
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;30.0.3" "cmake;3.18.1"
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;25.1.8937393"
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-33"
    popd
    export ANDROID_SDK_ROOT=$HOME/Android/sdk
else
    export JAVA_HOME=$JAVA_HOME_17_X64
    export PATH=$JAVA_HOME/bin:$PATH
    pushd /usr/local/lib/android/sdk/cmdline-tools/latest/bin
    yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "ndk;25.1.8937393"
    popd
    export ANDROID_SDK_ROOT=/usr/local/lib/android/sdk
fi
export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/25.1.8937393
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT

mkdir -p .zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output .zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output .zcash-params/sapling-spend.params
cp $HOME/.zcash-params/* $BUILD_DIR/assets/

git clone -b $FLUTTER_VERSION --depth 1 https://github.com/flutter/flutter.git flutter
export PATH=$PATH:$HOME/flutter/bin
flutter doctor -v

rustup target add aarch64-linux-android armv7-linux-androideabi
cargo install --force --version ^2 cargo-ndk
popd

sed -e 's/rlib/cdylib/' < native/zcash-sync/Cargo.toml >/tmp/out.toml
mv /tmp/out.toml native/zcash-sync/Cargo.toml

./configure.sh

cargo ndk --target arm64-v8a build --release --features=dart_ffi
mkdir -p ./packages/warp_api_ffi/android/src/main/jniLibs/arm64-v8a
cp ./target/aarch64-linux-android/release/libwarp_api_ffi.so ./packages/warp_api_ffi/android/src/main/jniLibs/arm64-v8a/
cargo ndk --target armeabi-v7a build --release --features=dart_ffi
mkdir -p ./packages/warp_api_ffi/android/src/main/jniLibs/armeabi-v7a
cp ./target/armv7-linux-androideabi/release/libwarp_api_ffi.so ./packages/warp_api_ffi/android/src/main/jniLibs/armeabi-v7a/

flutter build appbundle
flutter build apk

mv build/app/outputs/bundle/release/app-release.aab app-fdroid.aab
mv build/app/outputs/flutter-apk/app-release.apk app-fdroid.apk

echo "BUILD_DIR=$PWD" >> $GITHUB_OUTPUT

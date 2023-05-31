mkdir -p target/universal/release
lipo target/x86_64-apple-darwin/release/libwarp_api_ffi.dylib target/aarch64-apple-darwin/release/libwarp_api_ffi.dylib -output target/universal/release/libwarp_api_ffi.dylib -create
cp native/zcash-sync/binding.h packages/warp_api_ffi/ios/Classes/binding.h

git clone -b "$1" --depth 1 https://github.com/flutter/flutter.git flutter
flutter doctor -v

./configure.sh
flutter build macos

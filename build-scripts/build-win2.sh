# Codegen
flutter pub get
flutter pub run build_runner build -d
pushd packages/warp_api_ffi
flutter pub get
flutter pub run build_runner build -d
popd

# Build flutter
flutter build windows
cp runtime/* build/windows/runner/release
cp target/release/warp_api_ffi.dll build/windows/runner/release

# Disable MSIX - it hangs now
# flutter pub run msix:create
# mv build/windows/runner/Release/YWallet.msix .

# flutter build windows
cp runtime/* build/windows/runner/Release
pushd build/windows/runner
mv Release ywallet
7z a ../../../ywallet.zip ywallet
popd

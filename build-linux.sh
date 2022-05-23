# apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
# (cd native/warp_api_ffi; cargo build --release)
git config --global --add safe.directory /flutter
flutter config --enable-linux-desktop
flutter pub get
flutter build linux

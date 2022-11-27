# apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
git config --global --add safe.directory /flutter
flutter config --enable-linux-desktop
flutter pub get
flutter pub run build_runner build
cargo make flatpak
(cd packages/warp_api_ffi;flutter pub get;flutter pub run build_runner build)
flutter build linux

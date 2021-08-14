export COIN=$1

case $COIN in
ycash)
  export APP_TITLE=YWallet
  export APP_NAME=ywallet
  export FEATURE=ycash
  ;;
zcash)
  export APP_TITLE=ZWallet
  export APP_NAME=zwallet
  export FEATURE=
  ;;
esac

cp assets/$COIN.png assets/icon.png
cp lib/coin/$COIN.dart lib/coin/coindef.dart

flutter pub get
flutter pub run change_app_package_name:main me.hanh.$APP_NAME
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_launcher_name:main
flutter pub run build_runner build
cargo make --env COIN=$FEATURE --profile release
flutter build apk --split-per-abi

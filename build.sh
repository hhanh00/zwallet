export FEATURE=$1

cargo make --env COIN=$FEATURE --profile release
flutter build appbundle

export FEATURE=$1

cargo make --env COIN=$FEATURE --profile release
flutter build apk --split-per-abi

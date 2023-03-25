echo "Create keychain profile"
xcrun notarytool store-credentials "notarytool-profile" --apple-id "$1" --team-id "$2" --password "$3"

echo "Creating temp notarization archive"
ditto -c -k --keepParent "build/macos/Build/Products/Release/ywallet.app" "notarization.zip"

echo "Notarize app"
xcrun notarytool submit "notarization.zip" --keychain-profile "notarytool-profile" --wait

echo "Attach staple"
xcrun stapler staple "build/macos/Build/Products/Release/ywallet.app"

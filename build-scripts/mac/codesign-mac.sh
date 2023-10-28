# cert.p12 cert_pwd keychain_pwd cert_id
set -x
echo $1 | base64 --decode > certificate.p12
security create-keychain -p "$3" build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p "$3" build.keychain
security import certificate.p12 -k build.keychain -P "$2" -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$3" build.keychain
/usr/bin/codesign --force -s "$4" --deep --options runtime build/macos/Build/Products/Release/ywallet.app -v

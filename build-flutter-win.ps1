Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile \windows\system32\nuget.exe
nuget sources add -Source https://api.nuget.org/v3/index.json -Name nuget.org

flutter pub get
flutter pub run build_runner build
pushd packages\warp_api_ffi
flutter pub get
flutter pub run build_runner build
popd

flutter build windows
flutter pub run msix:create
pushd build\windows\runner
move-item Release\YWallet.msix .
rename-item Release ywallet
popd
copy runtime\* build\windows\runner\ywallet
copy warp_api_ffi.dll build\windows\runner\ywallet

pushd build\windows\runner
Compress-Archive -Path ywallet\ -DestinationPath ..\..\..\ywallet.zip
copy YWallet.msix ..\..\..
popd

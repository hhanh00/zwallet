# How to Build

The easiest way to build the release APKs is to use Docker.

Even if you prefer to setup your own dev environment, the `Dockerfile` is a good place to start.

I'll assume that you have cloned the repository in a directory called `$ZWALLET` (ex: `/home/user/zwallet`)

## Setup 

Before you start the build, you need a signing key for the app.

Detailed instructions are here: https://flutter.dev/docs/deployment/android#signing-the-app

In short, create a keystore `zwallet.jks` 

```shell
keytool -genkey -v -keystore $ZWALLET/docker/zwallet.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zwallet
```

Note: `keytool` comes from the JRE/JDK or Android Studio. If you use JRE/JDK, be advised that Java 11 is *not*
compatible and will create an unusable keystore.

The tool will ask for a password. Reuse the same password if asked for a second password.
Put the password in a text file. I'll refer to this file as `/home/user/jkspwd`.  

## Docker Builder

The Builder Image is a docker image that has all the tools needed: Android SDK, NDK, Flutter, Rust, etc.
You can build your own builder image or use the one that I have put in Docker Hub.

Skip the next section if you want to use my builder image.

Otherwise, from `$ZWALLET` run

`docker build -t zwallet_builder -f docker/Dockerfile-builder .`

After a while, you will have the `zwallet_builder` image.

Next edit the file `docker/Dockerfile` and change the line `FROM hhanh00/zwallet_builder AS builder`
to `FROM zwallet_builder AS builder`.

## Build

Run

`DOCKER_BUILDKIT=1 docker build -t zwallet -f docker/Dockerfile --secret id=pwd,src=/home/user/jkspwd .`

After 30mn to 1h, you will have the `zwallet` image.

## Get the APK

The APKs are in the Docker image. You need to copy it out. Unfortunately, there
is no way to directly copy files from images therefore you need to create a container.

```shell
docker run --name zwallet zwallet
docker cp zwallet:/root .
```

This will create a `root` directory will all the various apks (arm32, arm64, i32, x64)

## Notes

- On Windows, clone the repo with Unix line endings: `git clone ... --config core.autocrlf=input`
- The builder image is a ~3GB download and 7GB uncompressed.

## iOS

- pod install
- change bundle identifier / set signing profile
- Increase min OS version to 12.1
    - Runner/General/Deployment Info
    - Runner/Flutter/AppFramework.info
    - Pods

### Run in Simulator

- Change architecture to ARCHS_STANDARD (Runner & Pods)
- Add arm64 to Excluded Architecture / Any IOS Simulator SDK
- Build warp with x86_64-apple-ios target
- debugShowCheckedModeBanner: false in MaterialApp()

## Desktop builds

Desktop builds must be made on their native platform, i.e. MacOX
needs a Mac, etc.

First checkout how to use flutter desktop as there are requirements
for each platform.

The repository does not include the project generated files.
Run `flutter create --platform=windows,linux,macos .` to generate them.

First compile the rust code. In `native/zcash-sync`, edit `Cargo.toml`
to change the library crate type to `cdylib`. Then `cargo build --release --features=dart_ffi`.
This should produce a dynamic library under `target/release` in the project root
directory.

Depending on the platform, the output library has a different name and
a different way to include in the build.

Build the flutter project: `flutter build windows` (macos or linux).
The result is in `build/windows/runner/Release`.

### Linux (Flatpak)

- Use docker `Dockerfile-builder-linux` to create the builder image if you haven't done so,
- Build `zwallet.tgz` and `libwarp_api_ffi.so`
- Copy them into `misc`
- Build the flatpak package

```
rm -rf ~/repo
docker rm zwallet_linux

cd $PROJECT_ROOT
docker build -f docker/Dockerfile-builder-linux -t zwallet_builder_linux .
docker build -f docker/Dockerfile-linux -t zwallet_linux .
docker run --name zwallet_linux zwallet_linux
cd misc
docker cp zwallet_linux:/root .
flatpak-builder --user --install --force-clean build-dir me.hanh.zwallet.Ywallet.yml 
flatpak build-export ~/repo build-dir
flatpak build-bundle ~/repo ywallet.flatpak me.hanh.zwallet.Ywallet

rm -rf build-dir
rm -rf ~/repo
docker rm zwallet_linux
```

### Installation on Ubuntu
- Install NVidia drivers *515*
- Then,
```
apt get update
add-apt-repository ppa:flatpak/stable (if needed)
apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install ywallet.flatpak
```
- Check that the version number has 'CUDA' (in the about page)

### Windows
Copy `warp_api_ffi.dll` into the Release directory and also add:
- `sqlite3.dll`
- `msvcp140.dll`
- `vcruntime140.dll`
- `vcruntime140_1.dll`
Then zip.

For a MSIX,
```
flutter pub run msix:create
```

### MacOS
- On M1 macs, run rustup default stable-x86_64-apple-darwin for x64 and stable-aarch64-apple-darwin for M1
- MacOS is the trickiest one. Open the xcode workspace.
- Add in Signing & Capabilities: Network server & Client and R/W file access
to user selected files
- Update the appicons
- Go to the Runner project, Build Phases / Bundle Framework
- Add `target/release/libwarp_api_ffi.dylib`
Then exit xcode and run `flutter build macos`.

If you want to create a DMG, use the npm package appdmg

## One script dev installation on a fresh distribution of ArchLinux

Build an APK for Android

- Clone the source code from github
- Clone the submodules
- Install all the dev tools (rust, android sdk, ndk & flutter)
- Configure and build

```
$ git clone https://github.com/hhanh00/zwallet.git
$ cd zwallet
$ git submodule update --init
$ ./install-dev.sh
```

Your `apk` is `build/app/outputs/flutter-apk/app-release.apk`

## Vagrant

[HashiCorp Vagrant](https://www.vagrantup.com/) provides the same, easy workflow regardless of your role as a developer, operator, or designer. 
It leverages a declarative configuration file which describes all your software requirements, 
packages, operating system configuration, users, and more.

This is the easiest way to install and build an installable Android package. If you want to develop,
you'd probably be better installing an IDE and the dependencies (Flutter & Rust) independently.  

- Install the discsize plugin
- Use the `Vagrantfile` from `misc`
- vagrant up
- SSH to the box
- Add a partition to / that takes the remaining space (+30 GB)
- Update OS
- Install git
- Clone zwallet repo
- Clone submodules
- Install dependencies and build

```
$ vagrant plugin install vagrant-disksize
$ wget https://raw.githubusercontent.com/hhanh00/zwallet/main/misc/Vagrantfile
$ vagrant up
$ vagrant ssh
$ cat << EOF | sudo fdisk /dev/sda
n
3


w
EOF
$ sudo btrfs device add -f /dev/sda3 /
$ sudo pacman -Syu
$ sudo pacman -S --noconfirm git
$ git clone https://github.com/hhanh00/zwallet.git
$ cd zwallet
$ git submodule update --init
$ ./install-dev.sh
```

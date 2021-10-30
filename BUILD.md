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


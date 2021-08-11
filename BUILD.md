# How to Build

The easiest way to build the release APK is to use Docker.

Even if you prefer to setup your own dev environment, the `Dockerfile` is a good place to start.

## Setup 

Let's say you cloned the repository zwallet to `/home/user/zwallet`

The build instructions were tested on Linux but they should work on other platforms.
Before you start the build, you need a signing key for the app.

Detailed instructions are here: https://flutter.dev/docs/deployment/android#signing-the-app

In short, create a keystore `keys.jks` 

```shell
keytool -genkey -v -keystore ~/keys.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zwallet
```

and create `key.properties` that references `keys.jks` as follows

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=zwallet
storeFile=/zwallet/keys.jks
```

Then copy `keys.jks` to `/home/user/zwallet` and `key.properties` to `/home/user/zwallet/android`
Also copy the `.zcash-params` directory to `/home/user/zwallet`

## Build

Now you can run the build

```shell
docker build -t zwallet .
```

This may take a while but eventually you wil get a build image that contains the app-release.apk signed with
your key.

## Get the APK

The APK is in the Docker image and you need to copy it out. Unfortunately, there
is no way to directly copy files from images and you need to create a container.

```shell
docker run --name zwallet zwallet
docker cp zwallet:/root/app-release.apk .
```

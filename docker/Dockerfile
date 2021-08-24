#syntax=docker/dockerfile:1.2
FROM hhanh00/zwallet_builder AS builder

ENV ANDROID_SDK_ROOT /Android/sdk
ENV PATH $PATH:$ANDROID_SDK_ROOT/platform-tools:/flutter/bin
ENV ANDROID_NDK_HOME /Android/android-ndk-r21e

COPY . /zwallet

RUN --mount=type=secret,id=pwd cd /zwallet && ./configure.sh zcash && ./build.sh

FROM alpine:latest
WORKDIR /root
COPY --from=builder /zwallet/build/app/outputs/flutter-apk/* ./

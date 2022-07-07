#syntax=docker/dockerfile:1.2
# FROM hhanh00/zwallet_builder AS builder
FROM zwallet_builder AS builder

ENV ANDROID_SDK_ROOT /Android/sdk
ENV PATH $PATH:$ANDROID_SDK_ROOT/platform-tools:/flutter/bin
ENV ANDROID_NDK_HOME $ANDROID_SDK_ROOT/ndk/21.4.7075529

COPY . /zwallet

RUN git config --global --add safe.directory /root/flutter
RUN --mount=type=secret,id=pwd cd /zwallet && ./configure.sh zcash && ./build.sh

FROM alpine:latest
WORKDIR /root
COPY --from=builder /zwallet/build/app/outputs/bundle/release/* ./

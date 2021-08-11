FROM archlinux:base-devel AS builder

RUN mkdir -p /Android/sdk
ENV ANDROID_SDK_ROOT /Android/sdk
RUN pacman -Sy --noconfirm unzip jdk8-openjdk

RUN curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
RUN unzip sdk-tools.zip
RUN cd cmdline-tools/bin && yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses
RUN cd cmdline-tools/bin && yes | ./sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-30"
ENV PATH $PATH:$ANDROID_SDK_ROOT/platform-tools

RUN curl -o ndk.zip https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip
RUN cd /Android && unzip /ndk.zip
ENV ANDROID_NDK_HOME /Android/android-ndk-r21e

RUN pacman -Sy --noconfirm rustup
RUN rustup install stable
RUN cargo install --force cargo-make

RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.2.3-stable.tar.xz
RUN tar xvf flutter.tar.xz
ENV PATH $PATH:/flutter/bin

RUN rustup target add aarch64-linux-android
RUN rustup target add armv7-linux-androideabi
RUN rustup target add i686-linux-android
RUN rustup target add x86_64-linux-android

RUN pacman -Sy --noconfirm git

COPY . /zwallet
COPY .zcash-params /root/.zcash-params

RUN cd /zwallet && cargo make --profile release
RUN cd /zwallet && flutter pub get && flutter pub run build_runner build && flutter build apk

FROM alpine:latest
WORKDIR /root
COPY --from=builder /zwallet/build/app/outputs/flutter-apk/app-release.apk ./

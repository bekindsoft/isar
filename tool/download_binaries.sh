#!/bin/bash

if [ -z "$ISAR_VERSION" ]; then
    echo "ISAR_VERSION is not set";
    exit 2;
fi

binariesUrl="https://binaries.isar-community.dev/$ISAR_VERSION"


curl "${binariesUrl}/libisar_android_arm64.so" -o packages/isar_flutter_libs/android/src/main/jniLibs/arm64-v8a/libisar.so --create-dirs -L -f
curl "${binariesUrl}/libisar_android_armv7.so" -o packages/isar_flutter_libs/android/src/main/jniLibs/armeabi-v7a/libisar.so --create-dirs -L -f
curl "${binariesUrl}/libisar_android_x64.so" -o packages/isar_flutter_libs/android/src/main/jniLibs/x86_64/libisar.so --create-dirs -L

curl "${binariesUrl}/IsarCore.xcframework.zip" -o packages/isar_flutter_libs/darwin/isar_flutter_libs/IsarCore.xcframework.zip --create-dirs -L -f
unzip -o packages/isar_flutter_libs/darwin/isar_flutter_libs/IsarCore.xcframework.zip -d packages/isar_flutter_libs/darwin/isar_flutter_libs
rm packages/isar_flutter_libs/darwin/isar_flutter_libs/IsarCore.xcframework.zip

curl "${binariesUrl}/libisar_linux_x64.so" -o packages/isar_flutter_libs/linux/libisar.so --create-dirs -L -f
curl "${binariesUrl}/isar_windows_x64.dll" -o packages/isar_flutter_libs/windows/isar.dll --create-dirs -L -f

curl "${binariesUrl}/isar.wasm" -o isar.wasm -L -f
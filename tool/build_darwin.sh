set -e

export IPHONEOS_DEPLOYMENT_TARGET=12.0
export MACOSX_DEPLOYMENT_TARGET=10.14

# Isar Core ships as a dynamic framework: the symbols of a static library get
# dead-stripped from release builds, so Dart could not look them up.
FRAMEWORK=IsarCore
BUILD_DIR=target/darwin

rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios aarch64-apple-darwin x86_64-apple-darwin
cargo build --target aarch64-apple-ios --features sqlcipher --release
cargo build --target aarch64-apple-ios-sim --features sqlcipher --release
cargo build --target x86_64-apple-ios --features sqlcipher --release
cargo build --target aarch64-apple-darwin --features sqlcipher --release
cargo build --target x86_64-apple-darwin --features sqlcipher --release

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/ios-simulator $BUILD_DIR/macos
lipo "target/aarch64-apple-ios-sim/release/libisar.dylib" "target/x86_64-apple-ios/release/libisar.dylib" -output "$BUILD_DIR/ios-simulator/libisar.dylib" -create
lipo "target/aarch64-apple-darwin/release/libisar.dylib" "target/x86_64-apple-darwin/release/libisar.dylib" -output "$BUILD_DIR/macos/libisar.dylib" -create

# write_info_plist <path> <platform> <min os key> <min os version>
write_info_plist() {
    cat > "$1" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$FRAMEWORK</string>
	<key>CFBundleIdentifier</key>
	<string>dev.isar.$FRAMEWORK</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$FRAMEWORK</string>
	<key>CFBundlePackageType</key>
	<string>FMWK</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>CFBundleSupportedPlatforms</key>
	<array>
		<string>$2</string>
	</array>
	<key>$3</key>
	<string>$4</string>
</dict>
</plist>
EOF
}

# make_ios_framework <out dir> <dylib> <platform>
make_ios_framework() {
    local fw="$1/$FRAMEWORK.framework"
    mkdir -p "$fw"
    cp "$2" "$fw/$FRAMEWORK"
    install_name_tool -id "@rpath/$FRAMEWORK.framework/$FRAMEWORK" "$fw/$FRAMEWORK"
    write_info_plist "$fw/Info.plist" "$3" MinimumOSVersion "$IPHONEOS_DEPLOYMENT_TARGET"
}

# make_macos_framework <out dir> <dylib>
# macOS frameworks need the versioned bundle layout.
make_macos_framework() {
    local fw="$1/$FRAMEWORK.framework"
    mkdir -p "$fw/Versions/A/Resources"
    cp "$2" "$fw/Versions/A/$FRAMEWORK"
    install_name_tool -id "@rpath/$FRAMEWORK.framework/Versions/A/$FRAMEWORK" "$fw/Versions/A/$FRAMEWORK"
    write_info_plist "$fw/Versions/A/Resources/Info.plist" MacOSX LSMinimumSystemVersion "$MACOSX_DEPLOYMENT_TARGET"
    ln -s A "$fw/Versions/Current"
    ln -s "Versions/Current/$FRAMEWORK" "$fw/$FRAMEWORK"
    ln -s Versions/Current/Resources "$fw/Resources"
}

make_ios_framework $BUILD_DIR/ios "target/aarch64-apple-ios/release/libisar.dylib" iPhoneOS
make_ios_framework $BUILD_DIR/ios-simulator "$BUILD_DIR/ios-simulator/libisar.dylib" iPhoneSimulator
make_macos_framework $BUILD_DIR/macos "$BUILD_DIR/macos/libisar.dylib"

rm -rf $FRAMEWORK.xcframework $FRAMEWORK.xcframework.zip
xcodebuild \
    -create-xcframework \
    -framework $BUILD_DIR/ios/$FRAMEWORK.framework \
    -framework $BUILD_DIR/ios-simulator/$FRAMEWORK.framework \
    -framework $BUILD_DIR/macos/$FRAMEWORK.framework \
    -output $FRAMEWORK.xcframework

for binary in $FRAMEWORK.xcframework/*/$FRAMEWORK.framework/$FRAMEWORK; do
    if ! nm -gU "$binary" | grep -q ' T _isar_version$'; then
        echo "$binary does not export isar_version" >&2
        exit 1
    fi
done

zip -qry $FRAMEWORK.xcframework.zip $FRAMEWORK.xcframework

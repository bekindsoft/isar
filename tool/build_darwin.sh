set -e

export IPHONEOS_DEPLOYMENT_TARGET=12.0
export MACOSX_DEPLOYMENT_TARGET=10.14

rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios aarch64-apple-darwin x86_64-apple-darwin
cargo build --target aarch64-apple-ios --features sqlcipher --release
cargo build --target aarch64-apple-ios-sim --features sqlcipher --release
cargo build --target x86_64-apple-ios --features sqlcipher --release
cargo build --target aarch64-apple-darwin --features sqlcipher --release
cargo build --target x86_64-apple-darwin --features sqlcipher --release

mkdir -p target/ios-simulator target/macos
lipo "target/aarch64-apple-ios-sim/release/libisar.a" "target/x86_64-apple-ios/release/libisar.a" -output "target/ios-simulator/libisar.a" -create
lipo "target/aarch64-apple-darwin/release/libisar.a" "target/x86_64-apple-darwin/release/libisar.a" -output "target/macos/libisar.a" -create

rm -rf IsarCore.xcframework IsarCore.xcframework.zip
xcodebuild \
    -create-xcframework \
    -library target/aarch64-apple-ios/release/libisar.a \
    -library target/ios-simulator/libisar.a \
    -library target/macos/libisar.a \
    -output IsarCore.xcframework

zip -r IsarCore.xcframework.zip IsarCore.xcframework

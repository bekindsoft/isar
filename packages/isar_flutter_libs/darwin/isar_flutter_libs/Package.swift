// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "isar_flutter_libs",
    platforms: [
        .iOS("12.0"),
        .macOS("10.14"),
    ],
    products: [
        .library(name: "isar-flutter-libs", targets: ["isar_flutter_libs"])
    ],
    targets: [
        // A dynamic framework, so Xcode embeds it in the app and its exported
        // symbols survive release builds for Dart to look up.
        .binaryTarget(
            name: "IsarCore",
            path: "IsarCore.xcframework"
        ),
        .target(
            name: "isar_flutter_libs",
            dependencies: ["IsarCore"],
            path: "Plugin",
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        ),
    ]
)

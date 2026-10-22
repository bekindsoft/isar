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
        .binaryTarget(
            name: "IsarCore",
            path: "IsarCore.xcframework"
        ),
        .target(
            name: "CIsarCore",
            dependencies: ["IsarCore"],
            path: "Core",
            linkerSettings: [
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Security"),
            ]
        ),
        .target(
            name: "isar_flutter_libs",
            dependencies: ["CIsarCore"],
            path: "Plugin",
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        ),
    ]
)

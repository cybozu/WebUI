// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "WebUI",
    platforms: [
        .macOS("13.3"),
        .iOS("16.4"),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "WebUI",
            targets: ["WebUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", exact: "1.4.3")
    ],
    targets: [
        .target(
            name: "WebUI",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "WebUITests",
            dependencies: ["WebUI"],
            swiftSettings: swiftSettings
        )
    ]
)

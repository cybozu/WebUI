// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "WebUI",
    platforms: [
        .iOS("16.4"),
        .macOS("13.3"),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "WebUI",
            targets: ["WebUI"]
        )
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

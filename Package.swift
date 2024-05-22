// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebUI",
    platforms: [
        .macOS("13.3"),
        .iOS("16.4")
    ],
    products: [
        .library(
            name: "WebUI",
            targets: ["WebUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", exact: "1.3.0")
    ],
    targets: [
        .target(
            name: "WebUI",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("GlobalConcurrency"),
            ]
        ),
        .testTarget(
            name: "WebUITests",
            dependencies: ["WebUI"],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny")
            ]
        )
    ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Postie",
    platforms: [
        .macOS(.v10_15), .iOS(.v14)
    ],
    products: [
        .library(name: "Postie", targets: ["Postie"]),
        .library(name: "PostieMock", targets: ["PostieMock"])
    ],
    targets: [
        .target(name: "Postie", dependencies: []),
        .testTarget(name: "PostieTests", dependencies: ["Postie"]),

        .target(name: "PostieMock", dependencies: ["Postie"])
    ]
)

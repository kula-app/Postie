// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Postie",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        .library(name: "Postie", targets: ["Postie"]),
        .library(name: "PostieMock", targets: ["PostieMock"])
    ],
    dependencies: [
        .package(url: "https://github.com/MaxDesiatov/XMLCoder", .upToNextMajor(from: "0.16.0"))
    ],
    targets: [
        .target(name: "Postie", dependencies: [
            "URLEncodedFormCoding",
            "PostieUtils",
            "XMLCoder"
        ]),
        .testTarget(name: "PostieTests", dependencies: ["Postie", "PostieMock"]),

        .target(name: "PostieMock", dependencies: ["Postie"]),

        .target(name: "URLEncodedFormCoding", dependencies: ["PostieUtils"]),

        .target(name: "PostieUtils"),
        .testTarget(name: "PostieUtilsTests", dependencies: ["PostieUtils"]),
    ]
)

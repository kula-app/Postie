// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Postie",
    platforms: [
        //lint .macOS(.v12),
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Postie", targets: ["Postie"]),
        .library(name: "PostieMock", targets: ["PostieMock"])
    ],
    dependencies: [
        .package(url: "https://github.com/MaxDesiatov/XMLCoder", .upToNextMajor(from: "0.17.1")),
        //lint .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", .upToNextMajor(from: "0.58.2"))
    ],
    targets: [
        .target(name: "Postie", dependencies: [
            "URLEncodedFormCoding",
            "PostieUtils",
            "XMLCoder"
        ], plugins: [
            //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]),
        //dev .testTarget(name: "PostieTests", dependencies: [
        //dev     "Postie",
        //dev     "PostieMock"
        //dev ], plugins: [
        //dev     //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        //dev ]),

        .target(name: "PostieMock", dependencies: ["Postie"], plugins: [
            //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]),

        .target(name: "URLEncodedFormCoding", dependencies: ["PostieUtils"], plugins: [
            //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]),

        .target(name: "PostieUtils", plugins: [
            //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]),
        //dev .testTarget(name: "PostieUtilsTests", dependencies: ["PostieUtils"], plugins: [
        //dev     //lint .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        //dev ]),
    ]
)

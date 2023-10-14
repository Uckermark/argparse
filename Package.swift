// swift-tools-version: 5.7

import PackageDescription

let package: Package = Package(
    name: "ArgParse",
    products: [
        .library(
            name: "ArgParse",
            targets: ["ArgParse"]),
    ],
    targets: [
        // Core library
        .target(
            name: "ArgParse",
            dependencies: [],
            path: "Sources/ArgParse"
        ),

        // Example
        .executableTarget(
            name: "ArgParseTool",
            dependencies: ["ArgParse"],
            path: "Sources/ArgParseTool"
        ),

        // Tests
        .testTarget(
            name: "ArgParseTests",
            dependencies: ["ArgParse"],
            path: "Tests"
        )
    ]
)
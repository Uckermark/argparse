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
        .executableTarget(
            name: "ArgParseTool",
            dependencies: ["ArgParse"],
            path: "Sources/ArgParseTool"
        ),
        .target(
            name: "ArgParse",
            dependencies: [],
            path: "Sources/ArgParse"
        )
    ]
)
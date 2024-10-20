// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "VariadicArgumentConstructable"
let testTargetName = "\(packageName)Tests"

let package = Package(
    name: packageName,
        platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: packageName,
            targets: [packageName]
        ),
    ],
    targets: [
        .target(
            name: packageName,
            path: "Sources/VariadicArgumentConstructable"
        ),
        .testTarget(
            name: testTargetName,
            dependencies: ["VariadicArgumentConstructable"],
            path: "Tests/VariadicArgumentConstructableTests"
        ),
    ]
)

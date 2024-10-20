// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "VariadicArgumentConstructable"
let testTargetName = "\(packageName)Tests"

enum ProjectPaths: RawRepresentable {
    
    case sources
    case tests
    
    init?(rawValue: String) {
        return nil
    }
    
    var rawValue: String {
        switch self {
        case .sources:
            return "Sources/\(packageName)"
        case .tests:
            return "Tests/\(testTargetName)"
        }
    }
}

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
            path: ProjectPaths.sources.rawValue
        ),
        .testTarget(
            name: testTargetName,
            dependencies: ["VariadicArgumentConstructable"],
            path: ProjectPaths.tests.rawValue
        ),
    ]
)

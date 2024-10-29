// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Foundation",
    platforms: [
        .iOS(.v12),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Foundation",
            targets: ["Foundation"]
        )
    ],
    targets: [
        .target(
            name: "Http",
            path: "foundation/src"
        ),
        .testTarget(
            name: "FoundationTests",
            dependencies: ["Foundation"]
        ),
    ]
)

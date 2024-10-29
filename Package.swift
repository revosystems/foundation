// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Http",
    platforms: [
        .iOS(.v12)
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Http",
            targets: ["Http"]
        ),
    ],
    targets: [
        .target(
            name: "Http",
            dependencies: []
            path: "foundation/src"
        ),
        .testTarget(
            name: "HttpTests",
            dependencies: ["Http"]
        ),
    ]
)

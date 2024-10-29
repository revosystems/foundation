// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RevoFoundation",
    platforms: [
        .iOS(.v12),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "RevoFoundation",
            targets: ["RevoFoundation"]
        )
    ],
    targets: [
        .target(
            name: "RevoFoundation",
            path: "foundation/src"
        ),
        .testTarget(
            name: "RevoFoundationTests",
            dependencies: ["RevoFoundation"]
        ),
    ]
)

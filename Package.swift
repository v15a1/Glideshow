// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Glideshow",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Glideshow",
            targets: ["Glideshow"]),
    ],
    
    targets: [
        .target(
            name: "Glideshow",
            path : "Glideshow"),
        .testTarget(
            name: "GlideshowTests",
            dependencies: ["Glideshow"]),
    ]
)

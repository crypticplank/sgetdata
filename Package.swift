// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sgetdata",
    platforms: [
            .macOS(.v10_12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.4.1")),
        .package(url: "https://github.com/tsolomko/SWCompression.git",
                         from: "4.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "sgetdata",
            dependencies: ["SWCompression", "CryptoSwift", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "sgetdataTests",
            dependencies: ["sgetdata"]),
    ]
)

// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "import-path-bug",
    products: [
        .library(
            name: "Lib1",
            targets: ["Lib1"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", exact: "1.0.2"),
    ],
    targets: [
        .target(
            name: "Lib1",
            dependencies: [
              .product(name: "RealModule", package: "swift-numerics"),
            ],
            path: ".",
            sources: ["Lib1.swift"]
        )
    ]
)

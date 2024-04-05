// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "import-path-bug",
    targets: [
        .target(
            name: "Lib1",
            dependencies: ["Lib2"],
            path: "Lib1"
        ),
        .target(
            name: "Lib2",
            path: "Lib2"
        )
    ]
)

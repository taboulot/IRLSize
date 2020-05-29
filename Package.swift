// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "IRLSize",
    products: [
        .library(name: "IRLSize", targets: ["IRLSize"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SlaunchaMan/Orchard",
                 .branch("swiftpm-objc"))
    ],
    targets: [
        .target(
            name: "IRLSize",
            dependencies: [
                .product(name: "Orchard-ObjC", package: "Orchard")
            ]),
        .testTarget(
            name: "IRLSizeTests",
            dependencies: ["IRLSize"]),
    ]
)

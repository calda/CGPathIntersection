// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CGPathIntersection",
    platforms: [.iOS(.v9)],
    products: [
        .library(
          name: "CGPathIntersection",
          targets: ["CGPathIntersection"]),
    ],
    targets: [
      .target(
        name: "CGPathIntersection",
        path: "CGPathIntersection"),
      .testTarget(
        name: "CGPathIntersectionTests",
        dependencies: ["CGPathIntersection"],
        path: "CGPathIntersectionTests"),
    ]
)

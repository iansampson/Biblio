// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Biblio",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "Biblio",
                 targets: ["Biblio"]),
    ],
    dependencies: [
        .package(name: "FeedKit",
                 url: "https://github.com/nmdias/FeedKit",
                 branch: "master")],
    targets: [
        .target(name: "LibraryOfCongress",
                dependencies: ["FeedKit"]),
        .target(name: "GoogleBooks"),
        .target(name: "Biblio",
                dependencies: ["LibraryOfCongress", "GoogleBooks"]),
        .testTarget(name: "BiblioTests",
                    dependencies: ["Biblio"],
                    resources: [.process("Resources")])
    ]
)

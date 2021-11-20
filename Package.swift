// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Biblio",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "Biblio",
                 targets: ["Biblio"]),],
    dependencies: [
        .package(name: "FeedKit",
                 url: "https://github.com/nmdias/FeedKit",
                 branch: "master"),
        .package(name: "LetterCase",
                 url: "https://github.com/rwbutler/LetterCase",
                 from: .init(1, 0, 0)),
        .package(name: "SwiftSoup",
                 url: "https://github.com/scinfu/SwiftSoup.git",
                 from: "1.7.4"),
        .package(name: "Fuzi",
                 url: "https://github.com/cezheng/Fuzi",
                 from: "3.1.3")
    ],
    targets: [
        .target(name: "LibraryOfCongress",
                dependencies: ["FeedKit"]),
        .target(name: "GoogleBooks"),
        .target(name: "CrossRef",
               dependencies: ["LetterCase"]),
        .target(name: "Biblio",
                dependencies: ["SwiftSoup", "Fuzi", "LibraryOfCongress", "GoogleBooks", "CrossRef"]),
        .testTarget(name: "BiblioTests",
                    dependencies: ["Biblio"],
                    resources: [.process("Resources")])
    ]
)

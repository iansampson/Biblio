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
        .package(name: "ISBN",
                 url: "https://github.com/iansampson/ISBN",
                 branch: "main"),
        .package(name: "DOI",
                 url: "https://github.com/iansampson/DOI",
                 branch: "main")
    ],
    targets: [
        .target(name: "LibraryOfCongress",
                dependencies: ["FeedKit"]),
        .target(name: "GoogleBooks"),
        .target(name: "CrossRef",
               dependencies: ["LetterCase"]),
        .target(name: "Metadata",
               dependencies: ["SwiftSoup", "ISBN", "DOI"]),
        .target(name: "Biblio",
                dependencies: ["LibraryOfCongress", "GoogleBooks", "CrossRef", "Metadata"]),
        .testTarget(name: "BiblioTests",
                    dependencies: ["Biblio"],
                    resources: [.process("Resources")])
    ]
)

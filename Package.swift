// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIWindowBindable",
    
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
    ],
    
    products: [
        .library(
            name: "SwiftUIWindowBindable",
            targets: ["SwiftUIWindowBindable"]),
    ],
    
    dependencies: [ ],
    
    targets: [
        .target(
            name: "SwiftUIWindowBindable",
            dependencies: [])
    ]
)

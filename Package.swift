// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIWindowBinder",
    
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
    ],
    
    products: [
        .library(
            name: "SwiftUIWindowBinder",
            targets: ["SwiftUIWindowBinder"]),
    ],
    
    dependencies: [ ],
    
    targets: [
        .target(
            name: "SwiftUIWindowBinder",
            dependencies: [])
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnfionicAuthenticateSDK",
    products: [
        .library(
            name: "UnfionicAuthenticateSDK",
            targets: ["UnfionicAuthenticateSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "UnfionicAuthenticateSDK",
            dependencies: []),
        .testTarget(
            name: "UnfionicAuthenticateSDKTests",
            dependencies: ["UnfionicAuthenticateSDK"]),
    ]
)

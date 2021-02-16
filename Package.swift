// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnfionicAuthenticateSDK",
    platforms: [
        .macOS(.v10_14), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "UnfionicAuthenticateSDK",
            targets: ["UnfionicAuthenticateSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "UnfionicAuthenticateSDK",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "UnfionicAuthenticateSDKTests",
            dependencies: ["UnfionicAuthenticateSDK"]),
    ]
)

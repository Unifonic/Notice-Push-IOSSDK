// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnifonicNoticeSDK",
    platforms: [
        .macOS(.v10_14), .iOS(.v10), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "UnifonicNoticeSDK",
            targets: ["UnifonicNoticeSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "UnifonicNoticeSDK",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "UnifonicNoticeSDKTests",
            dependencies: ["UnifonicNoticeSDK"]),
    ]
)

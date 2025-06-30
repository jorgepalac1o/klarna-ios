// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "KlarnaMobileSDK",
    products: [
        .library(
            name: "KlarnaMobileSDK",
            targets: ["KlarnaMobileSDK", "KlarnaCore"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "KlarnaMobileSDK",
            url: "https://artifactory.klarna.net/artifactory/l-generic-mobilesdk-releases/klarna/feature/ios/sdk/2025-06-26/1514-1d952fb3-release/KlarnaMobileSDK/universal/KlarnaMobileSDK.xcframework.zip",
            checksum: "4682d9e7f10bfe93e71b31aa9f7a8f59f6e43606f575d5b28fa245307d6f66c5"
        ),
        .binaryTarget(
            name: "KlarnaCore",
            url: "https://artifactory.klarna.net/artifactory/l-generic-mobilesdk-releases/klarna/feature/ios/sdk/2025-06-26/1514-1d952fb3-release/KlarnaCore/universal/KlarnaCore.xcframework.zip",
            checksum: "e73ca12cacd534aba3bec60e8be847ef0f4ff08efc95d794e15eb1194de72ae3"
        ),
    ]
)

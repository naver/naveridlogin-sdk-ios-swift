// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NidThirdPartyLogin",
    defaultLocalization: "ko",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NidThirdPartyLogin",
            targets: ["NidThirdPartyLogin"]
        )
    ],
    targets: [
        .target(
            name: "NidThirdPartyLogin",
            dependencies: [
                "NidLogin"
            ],
            path: "Projects/NidThirdPartyLogin/Sources/NidOAuth",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "NidLogin",
            dependencies: [
                "NidCore",
                "NetworkKit"
            ],
            path: "Projects/NidThirdPartyLogin/Sources/NidLogin"
        ),
        .target(
            name: "NetworkKit",
            path: "Projects/NidThirdPartyLogin/Sources/NetworkKit"
        ),
        .target(
            name: "NidCore",
            path: "Projects/NidThirdPartyLogin/Sources/NidCore",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        )
    ],
    swiftLanguageVersions: [.v5]
)

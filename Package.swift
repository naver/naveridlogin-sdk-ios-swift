// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NidThirdPartyLogin",
    defaultLocalization: "ko",
    platforms: [.iOS(.v13)],
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
            resources: [.process("Resources")]
        ),
        .target(
            name: "NidLogin",
            dependencies: [
                "NidCore"
            ],
            path: "Projects/NidThirdPartyLogin/Sources/NidLogin"
        ),
        .target(
            name: "NetworkKit",
            dependencies: [
                "Utils"
            ],
            path: "Projects/NidThirdPartyLogin/Sources/NetworkKit"
        ),
        .target(
            name: "Utils",
            dependencies: [
            ],
            path: "Projects/NidThirdPartyLogin/Sources/Utils"
        ),
        .target(
            name: "NidCore",
            dependencies: [
                "Utils", "NetworkKit"
            ],
            path: "Projects/NidThirdPartyLogin/Sources/NidCore"
        )
    ],
    swiftLanguageVersions: [.v5]
)

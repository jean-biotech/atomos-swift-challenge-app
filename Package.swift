// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BioBridgeLab",
    platforms: [
        .iOS(.v17)
    ],
    targets: [
        .executableTarget(
            name: "BioBridgeLab",
            path: "BioBridgeLab",
            resources: [.process("Assets.xcassets")]
        )
    ]
)

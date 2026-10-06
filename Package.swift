// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AlgorithmLearning",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "AlgorithmLearning", targets: ["AlgorithmLearning"])
    ],
    targets: [
        .executableTarget(name: "AlgorithmLearning")
    ]
)

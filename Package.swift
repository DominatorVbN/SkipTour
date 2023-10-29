// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription
import Foundation

// Set SKIP_ZERO=1 to build without Skip libraries
let zero = ProcessInfo.processInfo.environment["SKIP_ZERO"] != nil
let skipstone = !zero ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []

let package = Package(
    name: "SkipTour",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipTour", type: .dynamic, targets: ["SkipTour"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.13"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "SkipTour",
            dependencies: (zero ? [] : [.product(name: "SkipUI", package: "skip-ui")]),
            resources: [.process("Resources")],
            plugins: skipstone
        ),
        .testTarget(
            name: "SkipTourTests",
            dependencies: ["SkipTour"] + (zero ? [] : [.product(name: "SkipTest", package: "skip")]),
            resources: [.process("Resources")],
            plugins: skipstone
        ),
    ]
)

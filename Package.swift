// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "writingBackup",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
      .package(url: "https://github.com/PerfectlySoft/Perfect.git", from: "3.0.0"),
      .package(url: "https://github.com/jdfergason/swift-toml", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
      .target(
        name: "writingBackup",
        dependencies: ["writingBackupCore"]),
        .target(
            name: "writingBackupCore",
            dependencies: ["PerfectLib", "Toml"]),
        .testTarget(
            name: "writingBackupTests",
            dependencies: ["writingBackupCore"]),
    ]
)

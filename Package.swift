// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeclarativeTextfield",
    platforms: [.macOS(.v10_10), .iOS(.v13), .watchOS(.v2), .tvOS(.v9) ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DeclarativeTextfield",
            targets: ["DeclarativeTextfield"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/aybekckaya/Debouncer.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DeclarativeTextfield",
            dependencies: ["Debouncer"]),
        .testTarget(
            name: "DeclarativeTextfieldTests",
            dependencies: ["DeclarativeTextfield"]),
    ]
)

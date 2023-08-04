// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Flamingo",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    .library(
      name: "Flamingo",
      targets: ["Flamingo"]
    ),
  ],
  targets: [
    .target(
      name: "Flamingo",
      dependencies: []
    ),
    .testTarget(
      name: "FlamingoTests",
      dependencies: [
        .target(name: "Flamingo")
      ]
    )
  ]
)

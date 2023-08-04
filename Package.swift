// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Networking",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    .library(
      name: "Networking",
      targets: ["Networking"]
    ),
  ],
  targets: [
    .target(
      name: "Networking",
      dependencies: []
    ),
    .testTarget(
      name: "NetworkingTests",
      dependencies: [
        .target(name: "Networking")
      ]
    )
  ]
)

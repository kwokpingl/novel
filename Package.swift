import PackageDescription

let package = Package(
  name: "Novel",
  targets: [
    Target(name: "Demo", dependencies: ["NovelCore", "NovelAdmin", "NovelAPI", "NovelTheme"]),
    Target(name: "NovelTheme", dependencies: ["NovelCore"]),
    Target(name: "NovelAPI", dependencies: ["NovelCore"]),
    Target(name: "NovelAdmin", dependencies: ["NovelCore"]),
    Target(name: "NovelCore"),
  ],
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 3),
    .Package(url: "https://github.com/vapor/postgresql-provider", majorVersion: 1, minor: 1),
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources"
  ]
)

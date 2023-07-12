# Case Accessors

[![Build & Test Swift Package](https://github.com/rhysforyou/swift-case-accessors/actions/workflows/swift-package.yml/badge.svg)](https://github.com/rhysforyou/swift-case-accessors/actions/workflows/swift-package.yml)
![Supports Swift 5.9+](https://img.shields.io/badge/swift-5.9%2B-blue)
![Supports macOS, iOS, tvOS, watchOS, and Linux](https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20iPadOS%20|%20tvOS%20|%20watchOS%20|%20visionOS%20|%20Linux-blue)
[![Licensed under the MIT License](https://img.shields.io/github/license/rhysforyou/swift-case-accessors?color=blue)](LICENSE)

[Swift Package Index listing](https://swiftpackageindex.com/rhysforyou/swift-case-accessors) • [Documentation](https://swiftpackageindex.com/rhysforyou/swift-case-accessors/main/documentation/caseaccessors) • [Compatibility](https://swiftpackageindex.com/rhysforyou/swift-case-accessors/builds)


This package offers macros that make destructuring enums with associated values more straightforward. 

The `@CaseAccessors` macro adds computed properties to an enum type that allow easy retrieval of associated values.

```swift
@CaseAccessors enum TestEnum {
    case stringValue(String)
    case intValue(Int)
    case boolValue(Bool)
}

let enumValue = TestEnum.stringValue("Hello, Macros!")

if let stringValue = enumValue.stringValue {
    print(stringValue) // Prints "Hello, Macros!"
}
```

The second, `@CaseConditionals` adds boolean computed properties that make it easier to perform conditional checks on enums.

```swift
@CaseConditionals enum TestEnum {
    case one, two, three
}

let enumValue = TestEnum.one

if enumValue.isOne {
    // Do something
}

// The above is equivalent to
if case .one = enumValue {
    // Do something
}
```

## Installation

Add the following to your `Package.swift`

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/rhysforyou/swift-case-accessors", "0.1.0"..<"0.2.0"),
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: ["CaseAccessors"]),
    ]
)
```

# ``CaseAccessors``

This package offers macros that make destructuring enums with associated values more straightforward. 

## Overview

The `@CaseAccessors` macro adds computed properties to an enum type that allow easy retrieval of associated values.

```swift
@CaseAccessors enum TestEnum {
    case stringValue(String)
    case intValue(Int)
    case boolValue(Bool)
}

let enumValue = TestEnum.string("Hello, Macros!")

if let stringValue = enumValue.stringValue {
    print(stringValue) // Prints "Hello, Macros!"
}
```

The `@CaseConditionals` macro adds boolean computed properties that make it easier to perform conditional checks on enums.

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

## Topics

### Macros

- ``CaseAccessors``
- ``CaseConditionals``

# Case Accessors

This package offers two macros that make destructuring enums with associated values more straightforward. 

The first, `@CaseAccessors`, adds computed properties to an enum type that allow easy retrieval of associated values.

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

## `@CaseAccessors`

This adds accessors for each of an `enum`'s cases with associated values, e.g. the following code:

```swift
@CaseAccessors enum TestEnum {
    case one(String)
    case two(Int)
    case three(Bool)
}
```

Expands out to the following:

```swift
enum TestEnum {
    case one(String)
    case two(Int)
    case three(Bool)
    
    var one: String? {
        if case .one(let value) = self {
            return value
        }
        return nil
    }

    var two: Int? {
        if case .two(let value) = self {
            return value
        }
        return nil
    }

    var three: Bool? {
        if case .three(let value) = self {
            return value
        }
        return nil
    }
}
```

## `@CaseConditionals`

This adds new members to an `enum` that let you perform a quick boolean check on an instance's `case`. For an enum with a case `one`, a method `isOne` will be generated that returns true when an instance's value is `one`.

E.g.:

```swift
@CaseConditionals enum TestEnum {
    case one(String)
    case two(Int)
    case three(Bool)
}
```

Expands out to the following:

```swift
enum TestEnum {
    case one(String)
    case two(Int)
    case three(Bool)
    
    var isOne: Bool {
        get {
            if case .one = self {
                return true
            }
            return false
        }
    }

    var isTwo: Bool {
        get {
            if case .two = self {
                return true
            }
            return false
        }
    }

    var isThree: Bool {
        get {
            if case .three = self {
                return true
            }
            return false
        }
    }
}
```

# Case Accessors Macro Demo

This is a demo of the new macro capabilities in Swift 5.9. It defines two new macros.

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

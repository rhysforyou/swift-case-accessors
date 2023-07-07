/// Adds accessors for each of an `enum`'s cases with associated values
///
/// E.g. the following code:
///
/// ```swift
/// @CaseAccessors enum TestEnum {
///     case one(String)
///     case two(Int)
///     case three(Bool)
/// }
/// ```
///
/// Expands out to the following:
///
/// ```swift
/// enum TestEnum {
///     case one(String)
///     case two(Int)
///     case three(Bool)
///
///     var one: String? {
///         if case .one(let value) = self {
///             return value
///         }
///         return nil
///     }
///
///     var two: Int? {
///         if case .two(let value) = self {
///             return value
///         }
///         return nil
///     }
///
///     var three: Bool? {
///         if case .three(let value) = self {
///             return value
///         }
///         return nil
///     }
/// }
/// ```
@attached(member, names: arbitrary)
public macro CaseAccessors() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseAccessorsMacro")

/// Adds new members to an `enum` that let you perform a quick boolean check on an instance's `case`. For an enum with a case `one`, a method `isOne` will be generated that returns true when an instance's value is `one`.
///
/// E.g.:
///
/// ```swift
/// @CaseConditionals enum TestEnum {
///     case one(String)
///     case two(Int)
///     case three(Bool)
/// }
/// ```
///
/// Expands out to the following:
///
/// ```swift
/// enum TestEnum {
///     case one(String)
///     case two(Int)
///     case three(Bool)
///
///     var isOne: Bool {
///         get {
///             if case .one = self {
///                 return true
///             }
///             return false
///         }
///     }
///
///     var isTwo: Bool {
///         get {
///             if case .two = self {
///                 return true
///             }
///             return false
///         }
///     }
///
///     var isThree: Bool {
///         get {
///             if case .three = self {
///                 return true
///             }
///             return false
///         }
///     }
/// }
/// ```
@attached(member, names: arbitrary)
public macro CaseConditionals() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseConditionalsMacro")

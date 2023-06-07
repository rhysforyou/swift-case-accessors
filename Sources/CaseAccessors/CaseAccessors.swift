/// A macro that adds accessors for each of an enums cases that have an associated value.
///
/// For each case with an associated value, an accessor with the same name will be added that returns an optional of that case's associated value.
///
/// ```
/// // Declaration
/// case foo(String)
///
/// // Generated accessor
/// var foo: String? { /* ... */
/// ```
@attached(member, names: arbitrary)
public macro CaseAccessors() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseAccessorsMacro")

@attached(member, names: arbitrary)
public macro CaseConditionals() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseConditionalsMacro")

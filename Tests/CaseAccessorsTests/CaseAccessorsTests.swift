import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CaseAccessorsMacros)
import CaseAccessorsMacros

let testMacros: [String: Macro.Type] = [
    "CaseAccessors": CaseAccessorsMacro.self
]
#endif

final class CaseAccessorsTests: XCTestCase {
    func testAccessors() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors enum Test {
                case one(String)
                case two(Int)
            }
            """,
            expandedSource: """
            enum Test {
                case one(String)
                case two(Int)
                var one: String? {
                    guard case let .one(value) = self else {
                        return nil
                    }
                    return value
                }
                var two: Int? {
                    guard case let .two(value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testAccessorsCompact() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors enum Test {
                case one(String), two(Int)
            }
            """,
            expandedSource: """
            enum Test {
                case one(String), two(Int)
                var one: String? {
                    guard case let .one(value) = self else {
                        return nil
                    }
                    return value
                }
                var two: Int? {
                    guard case let .two(value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testAccessorsMultipleAssociatedValues() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors enum Test {
                case one(String, Int)
            }
            """,
            expandedSource: """
            enum Test {
                case one(String, Int)
                var one: (String, Int)? {
                    guard case let .one(a, b) = self else {
                        return nil
                    }
                    return (a, b)
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testAccessorsOptional() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors enum Test {
                case one(String?)
            }
            """,
            expandedSource: """
            enum Test {
                case one(String?)
                var one: String? {
                    guard case let .one(value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testAccessorsNonEnum() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors struct Test {
                var one: String?
            }
            """,
            expandedSource: """
            struct Test {
                var one: String?
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "'@CaseAccessors' can only be applied to 'enum'",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testAccessorsNoAssociatedValues() throws {
#if canImport(CaseAccessorsMacros)
        assertMacroExpansion(
            """
            @CaseAccessors enum Test {
                case one, two, three
            }
            """,
            expandedSource: """
            enum Test {
                case one, two, three
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "'@CaseAccessors' was applied to an enum without any cases containing associated values",
                    line: 1,
                    column: 1,
                    severity: .warning
                )
            ],
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}

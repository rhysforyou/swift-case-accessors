import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CaseAccessorsMacros

let testMacros: [String: Macro.Type] = [
    "CaseAccessors": CaseAccessorsMacro.self
]

final class CaseAccessorsTests: XCTestCase {
    func testAccessors() {
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
                    guard case .one(let value) = self else {
                        return nil
                    }
                    return value
                }
                var two: Int? {
                    guard case .two(let value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessorsCompact() {
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
                    guard case .one(let value) = self else {
                        return nil
                    }
                    return value
                }
                var two: Int? {
                    guard case .two(let value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessorsMultipleAssociatedValues() {
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
                    guard case .one(let value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessorsOptional() {
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
                    guard case .one(let value) = self else {
                        return nil
                    }
                    return value
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAccessorsNonEnum() {
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
    }

    func testAccessorsNoAssociatedValues() {
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
    }
}

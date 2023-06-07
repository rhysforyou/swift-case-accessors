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
                    if case .one(let value) = self {
                        return value
                    }
                    return nil
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
}

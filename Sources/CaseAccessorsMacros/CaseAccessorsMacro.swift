import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct CaseAccessorsMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(
                node: Syntax(attribute),
                message: CaseAccessorsDiagnostic.notAnEnum
            ))
            return []
        }

        let members = enumDeclaration.memberBlock.members
        let caseDeclarations = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let caseElements = caseDeclarations.flatMap(\.elements)
        let caseElementsWithAssociatedValues = caseElements.filter { caseElement in
            caseElement.associatedValue != nil
        }

        guard !caseElementsWithAssociatedValues.isEmpty else {
            context.diagnose(Diagnostic(
                node: Syntax(attribute),
                message: CaseAccessorsDiagnostic.noCasesWithAssociatedValues
            ))
            return []
        }

        return caseElementsWithAssociatedValues.map { caseElement in
            let associatedValues = caseElement.associatedValue!.parameterList

            let returnTypeSyntax: TypeSyntax
            let valueBindings: String
            let returnValue: String

            if associatedValues.count == 1, associatedValues.first!.type.is(OptionalTypeSyntax.self) {
                returnTypeSyntax = associatedValues.first!.type
                valueBindings = "value"
                returnValue = "value"
            } else if associatedValues.count == 1 {
                returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: associatedValues.first!.type))
                valueBindings = "value"
                returnValue = "value"
            } else {
                let tupleType = TupleTypeSyntax(
                    elements: TupleTypeElementListSyntax {
                        for associatedValue in associatedValues {
                            TupleTypeElementSyntax(type: associatedValue.type)
                        }
                    }
                )

                returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: tupleType))
                valueBindings = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "y", "z"]
                    .prefix(associatedValues.count)
                    .joined(separator: ", ")
                returnValue = "(\(valueBindings))"
            }

            return """
            var \(caseElement.identifier): \(returnTypeSyntax) {
                guard case let .\(caseElement.identifier)(\(raw: valueBindings)) = self else {
                    return nil
                }
                return \(raw: returnValue)
            }
            """
        }
    }
}

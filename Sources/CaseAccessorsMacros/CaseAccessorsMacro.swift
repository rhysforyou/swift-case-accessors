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

            if associatedValues.count == 1, associatedValues.first!.type.is(OptionalTypeSyntax.self) {
                returnTypeSyntax = associatedValues.first!.type
            } else if associatedValues.count == 1 {
                returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: associatedValues.first!.type))
            } else {
                let tupleType = TupleTypeSyntax(
                    elements: TupleTypeElementListSyntax {
                        for associatedValue in associatedValues {
                            TupleTypeElementSyntax(type: associatedValue.type)
                        }
                    }
                )

                returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: tupleType))
            }

            return """
            var \(caseElement.identifier): \(returnTypeSyntax) {
                guard case .\(caseElement.identifier)(let value) = self else {
                    return nil
                }
                return value
            }
            """
        }
    }
}

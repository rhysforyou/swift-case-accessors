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
            let enumErrorDiagnostic = Diagnostic(
                node: Syntax(attribute),
                message: CaseAccessorsDiagnostic.notAnEnum
            )
            context.diagnose(enumErrorDiagnostic)
            return []
        }

        let caseDeclarations = enumDeclaration.memberBlock.members.compactMap { member in
            member.decl.as(EnumCaseDeclSyntax.self)
        }

        let caseElements = caseDeclarations.flatMap(\.elements)

        let caseElementsWithAssociatedValue = caseElements.filter { caseElement in
            caseElement.associatedValue != nil
        }

        return caseElementsWithAssociatedValue.map { caseElement in
            let associatedValues = caseElement.associatedValue!.parameterList

            if associatedValues.count == 1 {
                let returnType: TypeSyntax

                if associatedValues.first!.type.is(OptionalTypeSyntax.self) {
                    returnType = associatedValues.first!.type
                } else {
                    returnType = TypeSyntax(OptionalTypeSyntax(wrappedType: associatedValues.first!.type))
                }
                
                return """
                var \(caseElement.identifier): \(returnType) {
                    if case .\(caseElement.identifier)(let value) = self {
                        return value
                    }
                    return nil
                }
                """
            } else {
                let associatedValueTypes = associatedValues.map { TypeSyntax($0.type) }
                let tupleTypeElements = associatedValueTypes.map { TupleTypeElementSyntax(type: $0) }
                let tupleType = TupleTypeSyntax(
                    elements: TupleTypeElementListSyntax {
                        for type in tupleTypeElements {
                            type
                        }
                    }
                )

                let type = OptionalTypeSyntax(wrappedType: TypeSyntax(tupleType))


                return """
                var \(caseElement.identifier): \(type) {
                    if case .\(caseElement.identifier)(let value) = self {
                        return value
                    }
                    return nil
                }
                """
            }
        }
    }
}

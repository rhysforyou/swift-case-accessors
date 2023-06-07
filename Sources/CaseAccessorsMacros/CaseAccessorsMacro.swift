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

        let caseElementsWithSingleAssociatedValue = caseElements.filter { caseElement in
            guard let associatedValues = caseElement.associatedValue else { return false }

            return associatedValues.parameterList.count == 1
        }

        return caseElementsWithSingleAssociatedValue.map { caseElement in
            let associatedValue = caseElement.associatedValue!.parameterList.first!
            let type: TypeSyntax = associatedValue.type.is(OptionalTypeSyntax.self)
                ? associatedValue.type
                : TypeSyntax(OptionalTypeSyntax(wrappedType: associatedValue.type))

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

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct CaseConditionalsMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax]  {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(Diagnostic(
                node: Syntax(attribute),
                message: CaseConditionalsDiagnostic.notAnEnum
            ))
            return []
        }

        let members = enumDeclaration.memberBlock.members
        let caseDeclarations = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let caseElements = caseDeclarations.flatMap(\.elements)

        return caseElements.map { caseElement in
            let capitalizedIdentifier = caseElement.identifier.text.prefix(1).uppercased() +
                caseElement.identifier.text.dropFirst()

            return """
            var is\(raw: capitalizedIdentifier): Bool {
                get {
                    if case .\(caseElement.identifier) = self {
                        return true
                    }
                    return false
                }
            }
            """
        }
    }
}

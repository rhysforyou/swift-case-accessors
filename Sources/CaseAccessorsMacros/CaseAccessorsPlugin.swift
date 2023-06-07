import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CaseAccessorsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CaseAccessorsMacro.self,
        CaseConditionalsMacro.self,
    ]
}

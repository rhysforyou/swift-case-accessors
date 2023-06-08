import Foundation
import SwiftDiagnostics

enum CaseAccessorsDiagnostic: String, DiagnosticMessage {
    case notAnEnum
    case noCasesWithAssociatedValues

    var severity: DiagnosticSeverity {
        switch self {
        case .notAnEnum:
            return .error
        case .noCasesWithAssociatedValues:
            return .warning
        }
    }

    var message: String {
        switch self {
        case .notAnEnum:
            "'@CaseAccessors' can only be applied to 'enum'"
        case .noCasesWithAssociatedValues:
            "'@CaseAccessors' was applied to an enum without any cases containing associated values"
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "CaseAccessorMacros", id: rawValue)
    }
}

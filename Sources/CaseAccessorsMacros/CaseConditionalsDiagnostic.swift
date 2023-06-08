import Foundation
import SwiftDiagnostics

enum CaseConditionalsDiagnostic: String, DiagnosticMessage {
    case notAnEnum

    var severity: DiagnosticSeverity {
        switch self {
        case .notAnEnum:
            return .error
        }
    }

    var message: String {
        switch self {
        case .notAnEnum:
            "'@CaseConditionals' can only be applied to 'enum'"
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "CaseAccessorMacros", id: rawValue.appending("Conditional"))
    }
}

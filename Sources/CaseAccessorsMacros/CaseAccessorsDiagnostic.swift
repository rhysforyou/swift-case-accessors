import Foundation
import SwiftDiagnostics

enum CaseAccessorsDiagnostic: String, DiagnosticMessage {
    case notAnEnum

    var severity: DiagnosticSeverity { .error }

    var message: String {
        switch self {
        case .notAnEnum:
            "'@CaseAccessors' can only be applied to 'enum'"
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "CaseAccessorMacros", id: rawValue)
    }
}

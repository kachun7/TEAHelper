import Foundation

enum ScriptingError: Error {
    case executionFailed(status: Int)
    case invalidAccessibilityURL
    case processError(message: String)
}

extension ScriptingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .executionFailed(let status):
            return .init(localized: .scriptingExecutionFailed(status: status))
        case .invalidAccessibilityURL:
            return .init(localized: .scriptingInvalidAccessibilityURL)
        case .processError(let message):
            return .init(localized: .scriptingProcessError(message: message))
        }
    }
}

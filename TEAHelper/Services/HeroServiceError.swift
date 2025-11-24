import Foundation

enum HeroServiceError: Error {
    case directoryNotFound
    case fileNotFound
}

extension HeroServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .directoryNotFound:
            return .init(localized: .heroesDirectoryNotFound)
        case .fileNotFound:
            return .init(localized: .heroesFileNotFound)
        }
    }
}

import Foundation

struct URLLevel {
    let url: URL
    let level: Int

    nonisolated init?(url: URL) throws {
        self.url = url
        guard let level = try URLLevel.makeLevel(url: url) else { return nil }
        self.level = level
    }

    nonisolated private static func makeLevel(url: URL) throws -> Int? {
        let regex = "\\[Level(.*?)\\]\\.txt"
        let level = try url.lastPathComponent
            .extractCaptures(regexPattern: regex)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Int(level)
    }
}

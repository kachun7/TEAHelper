import Foundation

extension String {
    nonisolated func extractCaptures(regexPattern: String) throws -> [String] {
        let regex = try Regex(regexPattern)
        return matches(of: regex)
            .compactMap { $0.output[1].substring }
            .map { String($0) }
    }

    nonisolated func chunked(size: Int) -> [String] {
        guard size > 0 else { return [] }
        var chunks: [String] = []
        for offset in stride(from: 0, to: count, by: size) {
            guard let start = index(startIndex, offsetBy: offset, limitedBy: endIndex) else { break }
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            let chunk = String(self[start..<end])
            chunks.append(chunk)
        }
        return chunks
    }
}

extension String {
    static func random(
        length: Int,
        allowedCharacters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
    ) -> String {
        let characterSet = Array(allowedCharacters)
        return String((0..<length).compactMap { _ in characterSet.randomElement() })
    }
}

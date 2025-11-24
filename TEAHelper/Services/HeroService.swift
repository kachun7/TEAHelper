internal import Combine
import Foundation

actor HeroService {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func makeHeroDatas(url: URL) throws -> [HeroData] {
        try fetchDirectoryContents(fileManager: fileManager, url: url)
            .filter { $0.isDirectory }
            .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
            .map(makeHeroData(url:))
    }

    private func makeHeroData(url: URL) throws -> HeroData {
        let heroDetails = try fetchDirectoryContents(fileManager: fileManager, url: url)
            .filter { $0.pathExtension == Constants.textExtension }
            .compactMap(URLLevel.init(url:))
            .sorted(by: { $0.level < $1.level })
            .map(makeHeroDetails(urlLevel:))
        return .init(title: url.lastPathComponent, details: heroDetails)
    }

    private func makeHeroDetails(urlLevel: URLLevel) throws -> HeroDetails {
        let content = try fetchFileContents(url: urlLevel.url)
        return .init(
            level: urlLevel.level,
            content: try makeContent(content: content).joined(separator: Constants.newLine),
            loadCodes: try makeLoadCodes(content: content)
        )
    }

    private func fetchDirectoryContents(fileManager: FileManager, url: URL) throws -> [URL] {
        do {
            return try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
        } catch {
            throw HeroServiceError.directoryNotFound
        }
    }

    private func fetchFileContents(url: URL) throws -> String {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            throw HeroServiceError.fileNotFound
        }
    }

    private func makeContent(content: String) throws -> [String] {
        try content.extractCaptures(regexPattern: Constants.capturedContentPattern)
    }

    private func makeLoadCodes(content: String) throws -> [String] {
        let capturedContent = try content.extractCaptures(regexPattern: Constants.loadCodesPattern)
        var chunkStrings = capturedContent
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .chunked(size: Constants.chunkSize)
        if !chunkStrings.isEmpty {
            chunkStrings.insert(Constants.startLine, at: 0)
            chunkStrings.append(Constants.endLine)
        }
        return chunkStrings
    }

    private enum Constants {
        static let capturedContentPattern = "call Preload\\( \"(.*?)\" \\)"
        static let chunkSize = 120
        static let loadCodesPattern = "call Preload\\( \"-l(.*?)\" \\)"
        static let newLine = "\n"
        static let textExtension = "txt"
        static let startLine = "-lc"
        static let endLine = "-le"
    }
}

import Foundation

extension URL {
    var humanReadableString: String? {
        absoluteString.removingPercentEncoding
    }

    nonisolated var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

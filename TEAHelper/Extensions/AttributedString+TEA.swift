import Foundation
import SwiftUI

extension AttributedString {
    static func highlightOccurrences(
        in source: String,
        searchText: String,
        selectedForegroundColor: Color,
        selectedBackgroundColor: Color
    ) -> AttributedString {
        var attributedString = AttributedString(source)
        guard !searchText.isEmpty else { return attributedString }
        let lowerSource = source.lowercased()
        let lowerSearch = searchText.lowercased()
        var searchStart = lowerSource.startIndex
        while searchStart < lowerSource.endIndex,
              let range = lowerSource.range(of: lowerSearch, range: searchStart..<lowerSource.endIndex) {
            if let attributedRange = Range(range, in: attributedString) {
                attributedString[attributedRange].foregroundColor = selectedForegroundColor
                attributedString[attributedRange].backgroundColor = selectedBackgroundColor
            }
            searchStart = range.upperBound
        }
        return attributedString
    }
}

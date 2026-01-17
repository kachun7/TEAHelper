import Foundation

struct HeroDetails: Identifiable, Hashable, Sendable {
    let id = UUID()
    let level: Int
    let content: String
    let loadCodes: [String]
}

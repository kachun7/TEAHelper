import Foundation

struct HeroDetails: Identifiable, Hashable {
    let id = UUID()
    let level: Int
    let content: String
    let loadCodes: [String]
}

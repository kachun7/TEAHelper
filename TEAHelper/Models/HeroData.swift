import Foundation

struct HeroData: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let details: [HeroDetails]
}

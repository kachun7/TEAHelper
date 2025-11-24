import Foundation

struct HeroData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let details: [HeroDetails]
}

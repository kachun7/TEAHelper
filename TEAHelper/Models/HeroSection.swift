import Foundation

struct HeroSection: Identifiable, Hashable, Sendable {
    let id = UUID()
    let index: Int
    let data: HeroData
}

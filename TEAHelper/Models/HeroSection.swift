import Foundation

struct HeroSection: Identifiable, Hashable {
    let id = UUID()
    let index: Int
    let data: HeroData
}

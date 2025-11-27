import Foundation
import SwiftUI

actor PathService {
    var heroPathValues: AsyncStream<Void> { heroPathStream }

    private let heroPathContinuation: AsyncStream<Void>.Continuation
    private let heroPathStream: AsyncStream<Void>
    private let userDefaults: UserDefaults

    private(set) var heroesPathURL: URL? {
        didSet {
            if let heroesPathURL {
                userDefaults.set(heroesPathURL, forKey: Keys.heroesPath)
                userDefaults.synchronize()
                heroPathContinuation.yield()
            }
        }
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        heroesPathURL = userDefaults.url(forKey: Keys.heroesPath)
        (heroPathStream, heroPathContinuation) = AsyncStream.makeStream()
    }
    
    func setHeroPath(url: URL) {
        heroesPathURL = url
    }

    private enum Keys {
        static let heroesPath = "heroesPath"
    }
}

internal import Combine
import Foundation
import SwiftUI

actor PathService {
    let heroPathPublisher = PassthroughSubject<Void, Never>()

    private(set) var heroesPathURL: URL? {
        didSet {
            if let heroesPathURL {
                userDefaults.set(heroesPathURL, forKey: Keys.heroesPath)
                userDefaults.synchronize()
                heroPathPublisher.send(())
            }
        }
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        heroesPathURL = userDefaults.url(forKey: Keys.heroesPath)
    }
    
    func setHeroPath(url: URL) {
        heroesPathURL = url
    }

    private enum Keys {
        static let heroesPath = "heroesPath"
    }
}

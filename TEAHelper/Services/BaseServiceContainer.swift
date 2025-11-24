import SwiftUI

final class BaseServiceContainer {
    let heroService: HeroService
    let pathService: PathService
    let scriptingService: ScriptingService

    init() {
        heroService = .init(fileManager: .default)
        pathService = .init(userDefaults: .standard)
        scriptingService = .init()
    }
}

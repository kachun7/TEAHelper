import SwiftUI

@Observable @MainActor final class HeroesViewModel {
    let pathPickerSelected: @MainActor () -> Void
    let permissionSelected: @MainActor () -> Void

    var alertString: String?
    var heroDetailsSearchText = "" {
        didSet {
            if let content = heroDetails?.content {
                if heroDetailsSearchText.isEmpty {
                    heroDetailsContent = .init(content)
                } else {
                    heroDetailsContent = .highlightOccurrences(
                        in: content,
                        searchText: heroDetailsSearchText,
                        selectedForegroundColor: Constants.selectedForegroundColor,
                        selectedBackgroundColor: Constants.selectedBackgroundColor
                    )
                }
            }
        }
    }
    var heroDetailsSelection: HeroDetails? {
        didSet {
            if let heroDetails = heroDetailsSelection {
                selectHeroDetails(heroDetails)
            }
        }
    }
    var heroSectionsSearchText = "" {
        didSet {
            if heroSectionsSearchText.isEmpty {
                heroSections = initialHeroSections
            } else {
                heroSections = initialHeroSections
                    .filter { $0.data.title.localizedCaseInsensitiveContains(heroSectionsSearchText) }
            }
        }
    }
    var isExpandedHeroSections = [Bool]()
    var isHeroSectionsLoading = false

    private(set) var heroDetailsContent: AttributedString?
    private(set) var heroDetails: HeroDetails? {
        didSet {
            if let content = heroDetails?.content {
                heroDetailsContent = .init(content)
            } else {
                heroDetailsContent = nil
            }
            heroDetailsSearchText = ""
        }
    }
    private(set) var heroSections: [HeroSection] = []
    private(set) var isHeroContentsLoading = false
    private(set) var isLoadingCode = false

    private let pathService: PathService
    private let heroService: HeroService
    private let scriptingService: ScriptingService

    private var initialHeroSections: [HeroSection] = [] {
        didSet {
            heroSections = initialHeroSections
            isExpandedHeroSections = initialHeroSections.map { _ in false }
            heroDetails = nil
            heroSectionsSearchText = ""
        }
    }

    init(
        heroService: HeroService,
        pathService: PathService,
        scriptingService: ScriptingService,
        pathPickerSelected: @Sendable @escaping () -> Void,
        permissionSelected: @Sendable @escaping () -> Void
    ) {
        self.heroService = heroService
        self.pathService = pathService
        self.scriptingService = scriptingService
        self.pathPickerSelected = pathPickerSelected
        self.permissionSelected = permissionSelected

        Task { @MainActor [weak self] in
            for await _ in await pathService.heroPathValues {
                await self?.refreshHeroSections()
            }
        }
    }

    func onAppear() {
        Task { [weak self] in
            guard let self else { return }
            await scriptingService.checkPermission()
            refresh()
        }
    }

    func refresh() {
        Task { [weak self] in
            await self?.refreshHeroSections()
        }
    }

    private func refreshHeroSections() async {
        guard let url = await pathService.heroesPathURL else { return }
        isHeroSectionsLoading = true
        do {
            let heroData = try await heroService.makeHeroDatas(url: url)
            let heroSections = heroData.enumerated().map { HeroSection(index: $0, data: $1) }
            initialHeroSections = heroSections
        } catch let error as HeroServiceError {
            alertString = error.localizedDescription
        } catch {}
        isHeroSectionsLoading = false
    }

    func toggleHeroSections(sectionIndex: Int) {
        isExpandedHeroSections[sectionIndex].toggle()
    }

    private func selectHeroDetails(_ heroDetails: HeroDetails) {
            guard self.heroDetails != heroDetails else { return }
            isHeroContentsLoading = true
            self.heroDetails = .placeHolder
        Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: Constants.simulateDelay)
            self.heroDetails = heroDetails
            isHeroContentsLoading = false
        }
    }

    func loadCode(heroDetails: HeroDetails) {
        Task { [weak self] in
            guard let self else { return }
            guard !isLoadingCode else { return }
            defer {
                isLoadingCode = false
            }
            isLoadingCode = true
            guard !heroDetails.loadCodes.isEmpty else {
                alertString = .init(localized: .heroesNoLoadCodeFound)
                return
            }
            do {
                for code in heroDetails.loadCodes {
                    try await scriptingService.loadCode(line: code)
                }
            } catch let error as ScriptingError {
                alertString = error.localizedDescription
            } catch {}
        }
    }
}

private extension HeroDetails {
    static let placeHolder = HeroDetails(
        level: Constants.randomLevel,
        content: String.random(length: Int.random(in: Constants.randomMin...Constants.randomMax)),
        loadCodes: []
    )
}

private enum Constants {
    static let randomLevel = 0
    static let randomMin = 2_000
    static let randomMax = 5_000
    static let selectedForegroundColor = Color.selectedTextForeground
    static let selectedBackgroundColor = Color.selectedTextBackground
    static let simulateDelay: UInt64 = 300_000_000
}

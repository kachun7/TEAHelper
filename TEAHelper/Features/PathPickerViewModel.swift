import SwiftUI

@Observable @MainActor final class PathPickerViewModel {
    var alertTitle: String?
    var selectedURLString: String?
    var isImporterPresented = false

    private let pathService: PathService

    init(pathService: PathService) {
        self.pathService = pathService
        Task { @MainActor [weak self] in
            guard let self else { return }
            selectedURLString = await pathService.heroesPathURL?.humanReadableString
        }
    }

    func presentImporter() {
        isImporterPresented = true
    }

    func pathSelected(result: Result<[URL], any Error>) {
        switch result {
        case .success(let urls):
            Task { [weak self] in
                guard let self else { return }
                guard let url = urls.first else { return }
                await pathService.setHeroPath(url: url)
                selectedURLString = await pathService.heroesPathURL?.humanReadableString
            }
        case .failure(let error):
            alertTitle = error.localizedDescription
        }
    }
}

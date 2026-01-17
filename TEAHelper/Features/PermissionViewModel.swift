import SwiftUI

@Observable @MainActor final class PermissionViewModel {
    var alertString: String?

    private(set) var permissionState = ScriptingPermissionState.initial

    private let scriptingService: ScriptingService

    init(scriptingService: ScriptingService) {
        self.scriptingService = scriptingService
    }

    func requestPermission() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await scriptingService.requestPermission()
            } catch let error as ScriptingError {
                alertString = error.localizedDescription
            } catch { }
        }
    }

    func checkPermission() {
        Task { [weak self] in
            guard let self else { return }
            await scriptingService.checkPermission()
            permissionState = await scriptingService.state
        }
    }
}

import SwiftUI

@main
struct TEAHelperApp: App {
    @Environment(\.openWindow) private var openWindow
    @State private var baseServiceContainer = BaseServiceContainer()

    var body: some Scene {
        WindowGroup {
            HeroesView(
                viewModel: .init(
                    heroService: baseServiceContainer.heroService,
                    pathService: baseServiceContainer.pathService,
                    scriptingService: baseServiceContainer.scriptingService,
                    pathPickerSelected: {
                        Task { @MainActor in
                            presentWindow(id: .pathPicker)
                        }
                    },
                    permissionSelected: {
                        Task { @MainActor in
                            presentWindow(id: .permission)
                        }
                    }
                )
            )
        }
        WindowGroup(.pathViewTitle, id: WindowsViewID.pathPicker.rawValue) {
            PathPickerView(viewModel: .init(pathService: baseServiceContainer.pathService))
                .frame(minWidth: Constants.minWindowWidth, minHeight: Constants.minWindowHeight)
        }
        WindowGroup(.permissionViewTitle, id: WindowsViewID.permission.rawValue) {
            PermissionView(viewModel: .init(scriptingService: baseServiceContainer.scriptingService))
                .frame(minWidth: Constants.minWindowWidth, minHeight: Constants.minWindowHeight)
        }
    }

    private func presentWindow(id: WindowsViewID) {
        let activeWindow = NSApplication.shared.windows.first { $0.identifier?.rawValue.contains(id.rawValue) == true }
        if let activeWindow {
            activeWindow.makeKeyAndOrderFront(nil)
        } else {
            openWindow(id: id.rawValue)
        }
    }
}

private enum WindowsViewID: String {
    case pathPicker
    case permission
}

private enum Constants {
    static let minWindowWidth: CGFloat = 400
    static let minWindowHeight: CGFloat = 300
}

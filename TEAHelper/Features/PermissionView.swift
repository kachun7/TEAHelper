import SwiftUI

struct PermissionView: View {
    @State private(set) var viewModel: PermissionViewModel

    var body: some View {
        VStack(spacing: .outerPadding) {
            Image(systemName: viewModel.permissionState.image)
                .foregroundColor(viewModel.permissionState.foregroundColor)
                .font(.largeTitle)
            Text(viewModel.permissionState.status)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            if viewModel.permissionState == .failure {
                Button(.permissionGrantSystemSetting, action: viewModel.requestPermission)
                    .controlSize(.extraLarge)
                Button(.permissionReCheckStatus, action: viewModel.checkPermission)
                    .controlSize(.regular)
            }
            Spacer()
        }
        .padding()
        .onAppear(perform: viewModel.checkPermission)
        .presentAlert(title: $viewModel.alertString)
    }
}

private extension ScriptingPermissionState {
    var status: LocalizedStringResource {
        switch self {
        case .initial: .permissionChecking
        case .success: .permissionGranted
        case .failure: .permissionRequired
        }
    }

    var image: SystemImageNames {
        self == .success ? .checkmarkCircleFill : .exclamationTriangleFill
    }

    var foregroundColor: Color {
        self == .success ? .green : .red
    }
}

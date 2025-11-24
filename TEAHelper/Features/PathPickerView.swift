import SwiftUI
import UniformTypeIdentifiers

struct PathPickerView: View {
    @State private(set) var viewModel: PathPickerViewModel

    var body: some View {
        VStack(spacing: .outerPadding) {
            if let url = viewModel.selectedURLString {
                Text(.pathSelected)
                    .font(.headline)
                Text(url)
            } else {
                Text(.pathRequired)
            }
            Spacer()
            Button(.pathSelect, action: viewModel.presentImporter)
        }
        .padding()
        .fileImporter(
            isPresented: $viewModel.isImporterPresented,
            allowedContentTypes: [.directory],
            allowsMultipleSelection: false,
            onCompletion: viewModel.pathSelected
        )
        .presentAlert(title: $viewModel.alertTitle)
    }
}

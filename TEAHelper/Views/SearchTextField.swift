import SwiftUI

struct SearchTextField: View {
    let placeholder: LocalizedStringResource

    @Binding private(set) var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .autocorrectionDisabled()
            .safeAreaInset(edge: .leading) {
                Image(systemName: .magnifyingGlass)
            }
            .safeAreaInset(edge: .trailing) {
                if !text.isEmpty {
                    Button(systemImage: .xmarkCircleFill) {
                        text = ""
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.textFieldPadding)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: .cornerRadius))
    }
}

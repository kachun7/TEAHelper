import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding private(set) var title: String?

    func body(content: Content) -> some View {
        content
            .alert(
                title ?? "",
                isPresented: .init(
                    get: { title != nil },
                    set: { isPresented in
                        guard isPresented else { return }
                        title = nil
                    }
                )
            ) { }
    }
}

extension View {
    func presentAlert(title: Binding<String?>) -> some View {
        modifier(AlertViewModifier(title: title))
    }
}

import SwiftUI

struct Row: View {
    let title: String
    let tapped: () -> Void

    var body: some View {
        HStack {
            Text(title)
            Spacer()
        }
        .onTapGesture(perform: tapped)
    }
}

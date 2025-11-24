import Foundation
import SwiftUI

struct RefreshButton: View {
    @Binding private(set) var isRunning: Bool

    @MainActor let action: () -> Void

    @State private var degreesRotating = DegreesRotations.initial

    var body: some View {
        Button(action: action) {
            if isRunning {
                imageView.rotationEffect(.degrees(degreesRotating.rawValue))
            } else {
                imageView
            }
        }
        .onChange(of: isRunning) { _, newValue in
            if newValue {
                withAnimation(.linear(duration: Constants.animationDuration).repeatForever(autoreverses: false)) {
                    degreesRotating = .full
                }
            } else {
                withAnimation(.none) {
                    degreesRotating = .initial
                }
            }
        }
    }

    private var imageView: some View {
        Image(systemName: .arrowClockwise)
            .foregroundColor(isRunning ? .gray : .secondary)
    }
}

private enum DegreesRotations: Double {
    case full = 360.0
    case initial = 0.0
}

private enum Constants {
    static let animationDuration = 1.0
}

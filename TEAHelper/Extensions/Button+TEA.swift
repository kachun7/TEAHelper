import SwiftUI

extension Button where Label == Image {
     init(systemImage: SystemImageNames, action: @escaping @MainActor () -> Void) {
        self.init(action: action) {
            Image(systemName: systemImage.rawValue)
        }
    }
}

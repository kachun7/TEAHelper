import SwiftUI

extension Image {
     init(systemName: SystemImageNames) {
         self.init(systemName: systemName.rawValue)
    }
}

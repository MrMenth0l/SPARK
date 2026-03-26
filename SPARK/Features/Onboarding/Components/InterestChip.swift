import SwiftUI

struct InterestChip: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Chip(title: title, isSelected: isSelected)
    }
}

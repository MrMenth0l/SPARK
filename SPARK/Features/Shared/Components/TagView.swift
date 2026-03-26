import SwiftUI

struct TagView: View {
    let tag: Tag

    var body: some View {
        Chip(title: tag.name, isSelected: true, kind: .tag, accent: ColorTokens.accentStrong)
    }
}

import SwiftUI

struct TagPicker: View {
    let tags: [Tag]
    var onAdd: (String) -> Void
    var onRemove: (Tag) -> Void
    @State private var draftTag = ""

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.small) {
            SectionHeader(title: "Themes")
            HStack(alignment: .center, spacing: SpacingTokens.small) {
                StudioPanel(style: .archival, padding: nil) {
                    TextField("Add a theme", text: $draftTag)
                        .font(TypographyTokens.note)
                        .foregroundStyle(ColorTokens.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
                SPARKButton(title: "Add", variant: .secondary) {
                    guard !draftTag.isBlank else { return }
                    onAdd(draftTag)
                    draftTag = ""
                }
            }
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SpacingTokens.small) {
                        ForEach(tags) { tag in
                            Button(action: { onRemove(tag) }) {
                                HStack(spacing: 6) {
                                    TagView(tag: tag)
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(ColorTokens.secondaryText)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}

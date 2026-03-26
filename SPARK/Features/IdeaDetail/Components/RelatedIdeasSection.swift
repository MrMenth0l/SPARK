import SwiftUI

struct RelatedIdeasSection: View {
    let ideas: [IdeaSheet]
    var onOpen: (IdeaSheet) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.small) {
            SectionHeader(title: "Related threads")
            if ideas.isEmpty {
                Text("Connections appear as themes begin to overlap.")
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)
            } else {
                ForEach(ideas) { idea in
                    Button(action: { onOpen(idea) }) {
                        SPARKCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(idea.resolvedTitle)
                                    .font(TypographyTokens.bodyEmphasis)
                                    .foregroundStyle(ColorTokens.primaryText)
                                Text(idea.previewText)
                                    .font(TypographyTokens.note)
                                    .foregroundStyle(ColorTokens.secondaryText)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

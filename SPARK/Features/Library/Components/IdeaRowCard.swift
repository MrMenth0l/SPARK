import SwiftUI

struct IdeaRowCard: View {
    let idea: IdeaSheet
    var onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            StudioPanel(style: .archival, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
                VStack(alignment: .leading, spacing: 8) {
                    StudioKicker(title: "Idea")
                    Text(idea.resolvedTitle)
                        .font(TypographyTokens.bodyEmphasis)
                        .foregroundStyle(ColorTokens.primaryText)
                    Text(idea.previewText)
                        .font(TypographyTokens.note)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .lineLimit(3)
                    Text("Edited \(idea.updatedAt.relativeDayDescription())")
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.tertiaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}

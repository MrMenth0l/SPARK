import SwiftUI

struct ContinueThinkingCard: View {
    let idea: IdeaSheet
    var onResume: () -> Void

    var body: some View {
        Button(action: onResume) {
            StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
                VStack(alignment: .leading, spacing: SpacingTokens.small) {
                    StudioKicker(title: "Continue thought", tint: ColorTokens.accent)
                    Text(idea.resolvedTitle)
                        .font(TypographyTokens.sectionTitle)
                        .foregroundStyle(ColorTokens.primaryText)
                    Text(idea.previewText)
                        .font(TypographyTokens.note)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .lineLimit(3)
                    HStack {
                        Text("Last opened \(idea.updatedAt.relativeDayDescription())")
                            .font(TypographyTokens.caption)
                            .foregroundStyle(ColorTokens.tertiaryText)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(ColorTokens.accent)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

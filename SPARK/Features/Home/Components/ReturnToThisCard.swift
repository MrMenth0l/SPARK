import SwiftUI

struct ReturnToThisCard: View {
    let item: ResurfacedItem
    var onOpen: () -> Void
    var onBuild: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        StudioPanel(style: .archival, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.small) {
                StudioKicker(title: "Return to this")
                Text(item.title)
                    .font(TypographyTokens.bodyEmphasis)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(item.reason)
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.tertiaryText)
                Text(item.preview)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                    .lineLimit(3)

                HStack(spacing: SpacingTokens.medium) {
                    Button("Open", action: onOpen)
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.accent)
                        .buttonStyle(.plain)
                    Button("Continue", action: onBuild)
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                    Spacer()
                    Button("Dismiss", action: onDismiss)
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                }
            }
        }
    }
}

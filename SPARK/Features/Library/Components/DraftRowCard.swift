import SwiftUI

struct DraftRowCard: View {
    let draft: Draft
    var onResume: () -> Void

    var body: some View {
        Button(action: onResume) {
            StudioPanel(style: .archival, accent: ColorTokens.accentSoft, accentEdge: .leading, padding: SpacingTokens.large) {
                VStack(alignment: .leading, spacing: 8) {
                    StudioKicker(title: "Draft")
                    Text(draft.titleCandidate)
                        .font(TypographyTokens.bodyEmphasis)
                        .foregroundStyle(ColorTokens.primaryText)
                    Text(draft.text.isBlank ? "Awaiting the next pass." : draft.text)
                        .font(TypographyTokens.note)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .lineLimit(3)
                    Text("Updated \(draft.updatedAt.relativeDayDescription())")
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.tertiaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}

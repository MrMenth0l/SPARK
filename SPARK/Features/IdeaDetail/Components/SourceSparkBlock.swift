import SwiftUI

struct SourceStimulusBlock: View {
    let record: StimulusRecord
    var isCompressed: Bool = false
    var onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .leading, padding: isCompressed ? SpacingTokens.medium : SpacingTokens.large) {
                HStack(alignment: .top, spacing: SpacingTokens.medium) {
                    VStack(alignment: .leading, spacing: 8) {
                        StudioKicker(title: "Source stimulus · \(record.family.title)", tint: record.family.accentColor)
                        Text(record.title)
                            .font(TypographyTokens.bodyEmphasis)
                            .foregroundStyle(ColorTokens.primaryText)
                            .multilineTextAlignment(.leading)
                        Text(record.summary)
                            .font(TypographyTokens.footnote)
                            .foregroundStyle(ColorTokens.secondaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(isCompressed ? 1 : 2)
                        if !isCompressed, let cue = record.responseCue {
                            Text(cue)
                                .font(TypographyTokens.caption)
                                .foregroundStyle(ColorTokens.tertiaryText)
                                .lineLimit(2)
                        }
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(record.family.accentColor)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

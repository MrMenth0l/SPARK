import SwiftUI

struct SavedStimulusRow: View {
    let record: StimulusRecord
    var onOpen: () -> Void
    var onRespond: () -> Void
    var onBuild: () -> Void

    var body: some View {
        StudioPanel(style: .archival, accent: record.family.accentColor, accentEdge: .leading, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    StudioKicker(title: record.family.title, tint: record.family.accentColor)
                    Spacer()
                    if let domain = record.taxonomy.domains.first {
                        Chip(title: domain.title, isSelected: false, kind: .taxonomy, accent: record.family.accentColor)
                    }
                }
                Text(record.title)
                    .font(TypographyTokens.bodyEmphasis)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(record.summary)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                Text(record.buildCount + record.responseCount > 0 ? "Already shaping thinking" : "Still waiting for a first pass")
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.tertiaryText)
                HStack(spacing: SpacingTokens.small) {
                    SPARKButton(title: "Open", variant: .quiet, action: onOpen)
                    SPARKButton(title: "Respond", variant: .tertiary, action: onRespond)
                    SPARKButton(title: "Build", variant: .primary, action: onBuild)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

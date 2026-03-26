import SwiftUI

struct FeaturedStimulusCard: View {
    let record: StimulusRecord
    var onOpen: () -> Void
    var onSave: () -> Void
    var onRespond: () -> Void
    var onBuild: () -> Void

    var body: some View {
        StudioPanel(style: .focal, accent: record.family.accentColor, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.section) {
                Button(action: onOpen) {
                    VStack(alignment: .leading, spacing: SpacingTokens.section) {
                        if let heroMedia = record.heroMedia {
                            heroMediaBlock(heroMedia)
                        }

                        VStack(alignment: .leading, spacing: SpacingTokens.object) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    StudioKicker(title: record.stimulus.eyebrow ?? "Featured stimulus", tint: record.family.accentColor)
                                    Text(record.title)
                                        .font(TypographyTokens.display)
                                        .foregroundStyle(ColorTokens.primaryText)
                                }
                                Spacer(minLength: 0)
                                if let domain = record.taxonomy.domains.first {
                                    Chip(title: domain.title, isSelected: false, kind: .taxonomy, accent: record.family.accentColor)
                                }
                            }

                            Text(record.summary)
                                .font(TypographyTokens.deck)
                                .foregroundStyle(ColorTokens.primaryText)

                            if let responseCue = record.responseCue {
                                StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .leading, padding: SpacingTokens.medium) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        StudioKicker(title: "Response path", tint: record.family.accentColor)
                                        Text(responseCue)
                                            .font(TypographyTokens.note)
                                            .foregroundStyle(ColorTokens.primaryText)
                                    }
                                }
                            }

                            if let whyChosen = record.stimulus.whyChosen {
                                Text(whyChosen)
                                    .font(TypographyTokens.caption)
                                    .foregroundStyle(ColorTokens.tertiaryText)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)

                HStack(spacing: SpacingTokens.small) {
                    SPARKButton(title: "Respond", variant: .secondary, action: onRespond)
                    SPARKButton(title: "Build from this", variant: .primary, action: onBuild)
                }

                HStack {
                    Button(action: onSave) {
                        HStack(spacing: 6) {
                            Image(systemName: record.isSaved ? "bookmark.fill" : "bookmark")
                            Text(record.isSaved ? "Kept in Library" : "Keep for later")
                        }
                        .font(TypographyTokens.caption)
                        .foregroundStyle(record.family.accentColor)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button(action: onOpen) {
                        HStack(spacing: 6) {
                            Text(record.family.title)
                            Image(systemName: "arrow.up.right")
                        }
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private func heroMediaBlock(_ media: StimulusMedia) -> some View {
        switch record.stimulus.layoutEmphasis {
        case .splitComparison:
            VStack(alignment: .leading, spacing: SpacingTokens.small) {
                StimulusMediaView(media: media, height: 220, cornerRadius: RadiusTokens.folio, accent: record.family.washColor)
                Text("A contrast worth sitting with before you respond.")
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)
            }
        case .mechanism:
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StimulusMediaView(media: media, height: 200, cornerRadius: RadiusTokens.folio, accent: record.family.washColor)
                Label("Look for the underlying mechanism, not just the reference.", systemImage: "dial.low")
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)
            }
        default:
            StimulusMediaView(media: media, height: 272, cornerRadius: RadiusTokens.sheet, accent: record.family.washColor)
        }
    }
}

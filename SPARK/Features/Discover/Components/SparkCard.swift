import SwiftUI

struct StimulusCard: View {
    let record: StimulusRecord
    var onSave: () -> Void
    var onRespond: () -> Void
    var onBuild: () -> Void
    var onOpen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            Button(action: onOpen) {
                VStack(alignment: .leading, spacing: SpacingTokens.object) {
                    header
                    familyBody
                    responsePrompt
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            actionRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(StimulusSurfaceModifier(record: record))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.inline) {
            HStack(alignment: .top, spacing: SpacingTokens.small) {
                VStack(alignment: .leading, spacing: 8) {
                    StudioKicker(title: record.family.title, tint: record.family.accentColor)

                    Text(record.title)
                        .font(cardTitleFont)
                        .foregroundStyle(ColorTokens.primaryText)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: SpacingTokens.medium)

                if let domain = record.taxonomy.domains.first {
                    Chip(title: domain.title, isSelected: false, kind: .taxonomy, accent: record.family.accentColor)
                }
            }
        }
    }

    @ViewBuilder
    private var familyBody: some View {
        switch record.payload {
        case .artifact(let payload):
            VStack(alignment: .leading, spacing: SpacingTokens.object) {
                if let heroMedia = record.heroMedia {
                    StimulusMediaView(
                        media: heroMedia,
                        height: record.stimulus.layoutEmphasis == .visualHero ? 214 : 182,
                        cornerRadius: RadiusTokens.folio,
                        accent: record.family.washColor
                    )
                }
                Text(record.summary)
                    .font(TypographyTokens.deck)
                    .foregroundStyle(ColorTokens.primaryText)
                insightBlock(title: "Borrowable move", body: payload.borrowableMove)
            }
        case .caseStudy(let payload):
            VStack(alignment: .leading, spacing: SpacingTokens.object) {
                Text(record.summary)
                    .font(TypographyTokens.deck)
                    .foregroundStyle(ColorTokens.primaryText)
                ruledLine(title: "Situation", body: payload.situation)
                ruledLine(title: "Move", body: payload.move)
                ruledLine(title: "Lesson", body: payload.lesson)
            }
        case .contrast(let payload):
            VStack(alignment: .leading, spacing: SpacingTokens.object) {
                StudioKicker(title: payload.comparisonAxis, tint: ColorTokens.secondaryText)
                HStack(alignment: .top, spacing: SpacingTokens.small) {
                    comparisonBlock(title: payload.leftSide.label, body: payload.leftSide.summary)
                    Rectangle()
                        .fill(record.family.accentColor.opacity(0.28))
                        .frame(width: 1)
                    comparisonBlock(title: payload.rightSide.label, body: payload.rightSide.summary)
                }
                Text(payload.tension)
                    .font(TypographyTokens.deck)
                    .foregroundStyle(ColorTokens.primaryText)
            }
        case .pattern(let payload):
            VStack(alignment: .leading, spacing: SpacingTokens.object) {
                Text(record.summary)
                    .font(TypographyTokens.deck)
                    .foregroundStyle(ColorTokens.primaryText)
                insightBlock(title: "Mechanism", body: payload.mechanism)
                ruledLine(title: "Effect", body: payload.effect)
            }
        case .collision(let payload):
            VStack(alignment: .leading, spacing: SpacingTokens.object) {
                HStack(spacing: SpacingTokens.small) {
                    Chip(title: payload.worldA, isSelected: true, kind: .taxonomy, accent: record.family.accentColor)
                    Text("×")
                        .font(TypographyTokens.footnote)
                        .foregroundStyle(ColorTokens.tertiaryText)
                    Chip(title: payload.worldB, isSelected: true, kind: .taxonomy, accent: record.family.accentColor)
                }
                Text(payload.synthesisDirection)
                    .font(TypographyTokens.deck)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(record.summary)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
            }
        }
    }

    private var cardTitleFont: Font {
        switch record.stimulus.layoutEmphasis {
        case .editorialHero:
            return TypographyTokens.title
        case .visualHero:
            return TypographyTokens.sectionTitle
        case .splitComparison, .mechanism, .synthesis:
            return TypographyTokens.sectionTitle
        }
    }

    private func ruledLine(title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: SpacingTokens.small) {
            Rectangle()
                .fill(record.family.accentColor.opacity(0.32))
                .frame(width: 2)
            Text(body)
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.primaryText)
            Spacer(minLength: 0)
        }
        .overlay(alignment: .topLeading) {
            StudioKicker(title: title, tint: ColorTokens.secondaryText)
                .offset(x: 12, y: -14)
        }
    }

    private func insightBlock(title: String, body: String) -> some View {
        StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .leading, padding: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 8) {
                StudioKicker(title: title, tint: record.family.accentColor)
                Text(body)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
            }
        }
    }

    private func comparisonBlock(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            StudioKicker(title: title, tint: record.family.accentColor)
            Text(body)
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var responsePrompt: some View {
        if let responseCue = record.responseCue {
            VStack(alignment: .leading, spacing: 6) {
                StudioKicker(title: "Response path", tint: ColorTokens.secondaryText)
                Text(responseCue)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                    .lineLimit(2)
            }
        }
    }

    @ViewBuilder
    private var actionRow: some View {
        HStack(spacing: SpacingTokens.small) {
            Button(action: onSave) {
                HStack(spacing: 6) {
                    Image(systemName: record.isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 12, weight: .semibold))
                    Text(record.isSaved ? "Kept" : "Keep")
                }
                .font(TypographyTokens.caption)
                .foregroundStyle(record.family.accentColor)
            }
            .buttonStyle(.plain)

            Spacer()

            inlineAction(title: "Respond", action: onRespond)
            inlineAction(title: "Build", action: onBuild)
        }
    }

    private func inlineAction(title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .font(TypographyTokens.caption)
            .foregroundStyle(ColorTokens.secondaryText)
            .buttonStyle(.plain)
    }
}

private struct StimulusSurfaceModifier: ViewModifier {
    let record: StimulusRecord

    func body(content: Content) -> some View {
        StudioPanel(
            style: panelStyle,
            accent: record.family.accentColor,
            accentEdge: .top,
            padding: SpacingTokens.large
        ) {
            content
        }
    }

    private var panelStyle: StudioPanelStyle {
        switch record.stimulus.layoutEmphasis {
        case .visualHero, .editorialHero:
            return .focal
        case .splitComparison:
            return .elevated
        case .mechanism, .synthesis:
            return .quiet
        }
    }
}

import SwiftUI

struct StimulusDetailSheet: View {
    let record: StimulusRecord
    var onSave: () -> Void
    var onRespond: () -> Void
    var onBuild: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.xxLarge) {
                if let heroMedia = record.heroMedia {
                    StimulusMediaView(
                        media: heroMedia,
                        height: 300,
                        cornerRadius: RadiusTokens.sheet,
                        accent: record.family.washColor
                    )
                }

                VStack(alignment: .leading, spacing: SpacingTokens.large) {
                    header
                    summarySection

                    if let detailBody = record.detailBody {
                        Text(detailBody)
                            .font(TypographyTokens.note)
                            .foregroundStyle(ColorTokens.secondaryText)
                            .lineSpacing(4)
                    }

                    if let responseCue = record.responseCue {
                        insightPanel(title: "Response path", body: responseCue)
                    }

                    familySections

                    if let whyChosen = record.stimulus.whyChosen {
                        insightPanel(title: "Why this belongs here", body: whyChosen)
                    }
                }
            }
            .modifier(ScreenPaddingModifier(style: .airy))
            .padding(.vertical, SpacingTokens.pageTop)
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .navigationTitle("Stimulus")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            StudioPanel(style: .floating, padding: nil) {
                VStack(spacing: SpacingTokens.small) {
                    HStack(spacing: SpacingTokens.small) {
                        SPARKButton(title: "Respond", variant: .secondary, action: onRespond)
                        SPARKButton(title: "Build from this", variant: .primary, action: onBuild)
                    }
                    SPARKButton(
                        title: record.isSaved ? "Kept in Library" : "Keep for later",
                        systemImage: "bookmark",
                        variant: .tertiary,
                        action: onSave
                    )
                }
                .padding(.horizontal, SpacingTokens.pageInset)
                .padding(.top, SpacingTokens.medium)
                .padding(.bottom, SpacingTokens.medium)
            }
            .padding(.horizontal, SpacingTokens.pageInset)
            .padding(.top, SpacingTokens.small)
            .background(Color.clear)
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 8) {
                StudioKicker(title: record.stimulus.eyebrow ?? record.family.title, tint: record.family.accentColor)
                Text(record.title)
                    .font(TypographyTokens.display)
                    .foregroundStyle(ColorTokens.primaryText)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
            if let domain = record.taxonomy.domains.first {
                Chip(title: domain.title, isSelected: false, kind: .taxonomy, accent: record.family.accentColor)
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.inline) {
            Text(record.summary)
                .font(TypographyTokens.deck)
                .foregroundStyle(ColorTokens.primaryText)
            if let source = record.provenance.sourceRefs.first {
                Text(source.title)
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.tertiaryText)
            }
        }
    }

    @ViewBuilder
    private var familySections: some View {
        switch record.payload {
        case .artifact(let payload):
            insightPanel(title: "Observed object", body: payload.observedObject)
            insightPanel(title: "Borrowable move", body: payload.borrowableMove)
            detailList(title: "Focus points", items: payload.focusPoints)
        case .caseStudy(let payload):
            ruledDetail(title: "Situation", body: payload.situation)
            ruledDetail(title: "Move", body: payload.move)
            ruledDetail(title: "Outcome", body: payload.outcome)
            ruledDetail(title: "Lesson", body: payload.lesson)
        case .contrast(let payload):
            insightPanel(title: "Comparison axis", body: payload.comparisonAxis)
            HStack(alignment: .top, spacing: SpacingTokens.small) {
                sideDetail(payload.leftSide)
                sideDetail(payload.rightSide)
            }
            insightPanel(title: "Tension", body: payload.tension)
            insightPanel(title: "Editorial take", body: payload.editorialTake)
        case .pattern(let payload):
            insightPanel(title: "Mechanism", body: payload.mechanism)
            ruledDetail(title: "Conditions", body: payload.conditions)
            ruledDetail(title: "Effect", body: payload.effect)
            ruledDetail(title: "Use it in", body: payload.whereItApplies)
            if let misuseWarning = payload.misuseWarning {
                ruledDetail(title: "Watch out", body: misuseWarning)
            }
        case .collision(let payload):
            HStack(spacing: SpacingTokens.small) {
                Chip(title: payload.worldA, isSelected: true, kind: .taxonomy, accent: record.family.accentColor)
                Chip(title: payload.worldB, isSelected: true, kind: .taxonomy, accent: record.family.accentColor)
            }
            insightPanel(title: "Premise", body: payload.collisionPremise)
            insightPanel(title: "Synthesis", body: payload.synthesisDirection)
            ruledDetail(title: "Build angle", body: payload.buildAngle)
        }
    }

    private func insightPanel(title: String, body: String) -> some View {
        StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .leading, padding: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 6) {
                StudioKicker(title: title, tint: record.family.accentColor)
                Text(body)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                    .lineSpacing(3)
            }
        }
    }

    private func ruledDetail(title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: SpacingTokens.small) {
            Rectangle()
                .fill(record.family.accentColor.opacity(0.3))
                .frame(width: 2)
            Text(body)
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.primaryText)
        }
        .overlay(alignment: .topLeading) {
            StudioKicker(title: title, tint: ColorTokens.secondaryText)
                .offset(x: 12, y: -14)
        }
    }

    private func detailList(title: String, items: [String]) -> some View {
        StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .leading, padding: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 10) {
                StudioKicker(title: title, tint: record.family.accentColor)
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundStyle(record.family.accentColor)
                        Text(item)
                            .font(TypographyTokens.note)
                            .foregroundStyle(ColorTokens.primaryText)
                    }
                }
            }
        }
    }

    private func sideDetail(_ side: ContrastSide) -> some View {
        StudioPanel(style: .quiet, accent: record.family.accentColor, accentEdge: .top, padding: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 8) {
                StudioKicker(title: side.label, tint: record.family.accentColor)
                Text(side.summary)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                    .lineSpacing(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

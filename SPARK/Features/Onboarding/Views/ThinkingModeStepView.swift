import SwiftUI

struct ThinkingModeStepView: View {
    let selectedMode: CaptureMode
    let selectedRhythm: CreativeRhythm
    let selectMode: (CaptureMode) -> Void
    let selectRhythm: (CreativeRhythm) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.xxLarge) {
            VStack(alignment: .leading, spacing: SpacingTokens.small) {
                Text("How should SPARK meet you?")
                    .font(TypographyTokens.sectionTitle)
                    .foregroundStyle(ColorTokens.primaryText)
                Text("Set the first doorway into the studio, then choose how much range you want around it.")
                    .font(TypographyTokens.body)
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                Text("When an idea arrives, where do you begin?")
                    .font(TypographyTokens.bodyEmphasis)
                    .foregroundStyle(ColorTokens.primaryText)

                ForEach(CaptureMode.allCases) { mode in
                    Button(action: { selectMode(mode) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(mode.title)
                                    .font(TypographyTokens.bodyEmphasis)
                                Text(mode == .write ? "Reach for language first." : mode == .voice ? "Think out loud and keep the pace." : "Jot shapes, maps, and fragments.")
                                    .font(TypographyTokens.footnote)
                                    .foregroundStyle(ColorTokens.secondaryText)
                            }
                            Spacer()
                            Image(systemName: selectedMode == mode ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedMode == mode ? ColorTokens.accent : ColorTokens.cardBorder)
                        }
                        .modifier(CardStyleModifier())
                    }
                    .buttonStyle(.plain)
                }
            }

            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                Text("How much room should Home leave open?")
                    .font(TypographyTokens.bodyEmphasis)
                    .foregroundStyle(ColorTokens.primaryText)

                ForEach(CreativeRhythm.allCases) { rhythm in
                    Button(action: { selectRhythm(rhythm) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(rhythm.title)
                                    .font(TypographyTokens.bodyEmphasis)
                                    .foregroundStyle(ColorTokens.primaryText)
                                Text(rhythmDescription(for: rhythm))
                                    .font(TypographyTokens.footnote)
                                    .foregroundStyle(ColorTokens.secondaryText)
                            }
                            Spacer()
                            Image(systemName: selectedRhythm == rhythm ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedRhythm == rhythm ? ColorTokens.accent : ColorTokens.cardBorder)
                        }
                        .modifier(CardStyleModifier())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func rhythmDescription(for rhythm: CreativeRhythm) -> String {
        switch rhythm {
        case .dailySparks:
            return "Lead with one strong daily entry point."
        case .freeExplore:
            return "Keep Discover close whenever you want more range."
        case .both:
            return "Balance a calm lead with room to widen out."
        }
    }
}

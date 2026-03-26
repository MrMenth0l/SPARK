import SwiftUI

struct RhythmStepView: View {
    let selectedRhythm: CreativeRhythm
    let select: (CreativeRhythm) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            Text("How do you want SPARK to meet you?")
                .font(TypographyTokens.sectionTitle)
                .foregroundStyle(ColorTokens.primaryText)
            ForEach(CreativeRhythm.allCases) { rhythm in
                Button(action: { select(rhythm) }) {
                    HStack {
                        Text(rhythm.title)
                            .font(TypographyTokens.bodyEmphasis)
                            .foregroundStyle(ColorTokens.primaryText)
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

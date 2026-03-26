import SwiftUI

struct OnboardingCompleteView: View {
    let state: OnboardingState

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.xxLarge) {
            VStack(alignment: .leading, spacing: SpacingTokens.large) {
                Text("Your studio is ready.")
                    .font(TypographyTokens.hero)
                    .foregroundStyle(ColorTokens.primaryText)
                Text("Home will lead with one stronger object, while capture stays close the moment a thought forms.")
                    .font(TypographyTokens.body)
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            VStack(alignment: .leading, spacing: SpacingTokens.large) {
                Text("First look")
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)

                VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                    Text("Quiet capability")
                        .font(.system(.title2, design: .serif, weight: .semibold))
                        .foregroundStyle(ColorTokens.primaryText)
                    Text("A calm object can still make the user feel more capable than a louder one.")
                        .font(TypographyTokens.body)
                        .foregroundStyle(ColorTokens.primaryText)
                    Text("Your Home rhythm: \(homeRhythmLine)")
                        .font(TypographyTokens.footnote)
                        .foregroundStyle(ColorTokens.secondaryText)
                }
                .padding(SpacingTokens.large)
                .background(
                    RoundedRectangle(cornerRadius: RadiusTokens.sheet, style: .continuous)
                        .fill(Color.white.opacity(0.72))
                        .overlay(
                            RoundedRectangle(cornerRadius: RadiusTokens.sheet, style: .continuous)
                                .stroke(ColorTokens.cardBorder, lineWidth: 1)
                        )
                )

                HStack(spacing: SpacingTokens.small) {
                    Label("Begin in \(state.preferredMode.title)", systemImage: state.preferredMode.systemImage)
                        .font(TypographyTokens.bodyEmphasis)
                        .foregroundStyle(ColorTokens.primaryText)
                        .padding(.horizontal, SpacingTokens.medium)
                        .padding(.vertical, 12)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.white.opacity(0.65))
                                .overlay(Capsule(style: .continuous).stroke(ColorTokens.cardBorder, lineWidth: 1))
                        )

                    Text("Voice and sketch stay one reach away.")
                        .font(TypographyTokens.footnote)
                        .foregroundStyle(ColorTokens.secondaryText)
                }
            }

            Spacer()
        }
    }

    private var homeRhythmLine: String {
        switch state.creativeRhythm {
        case .dailySparks:
            return "one strong daily lead"
        case .freeExplore:
            return "faster access to Discover"
        case .both:
            return "a calm lead with a wider room nearby"
        }
    }
}

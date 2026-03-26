import SwiftUI

struct WelcomeStepView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            Spacer()
            Text("Train your creative edge.")
                .font(TypographyTokens.hero)
                .foregroundStyle(ColorTokens.primaryText)
            Text("Enter a calmer studio for stronger stimuli, fluid capture, and thought that has room to grow.")
                .font(TypographyTokens.body)
                .foregroundStyle(ColorTokens.secondaryText)
            Spacer()
        }
    }
}

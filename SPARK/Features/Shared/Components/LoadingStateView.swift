import SwiftUI

struct LoadingStateView: View {
    var message: String = "Preparing your studio..."

    var body: some View {
        VStack(spacing: SpacingTokens.section) {
            StudioPanel(style: .quiet, padding: SpacingTokens.large) {
                VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                    StudioKicker(title: "Setting the room")
                    ProgressView()
                        .tint(ColorTokens.accent)
                    Text(message)
                        .font(TypographyTokens.note)
                        .foregroundStyle(ColorTokens.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, SpacingTokens.pageInset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sparkScreenBackground()
    }
}

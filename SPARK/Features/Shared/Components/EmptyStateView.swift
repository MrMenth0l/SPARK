import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        StudioPanel(style: .quiet, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Quiet room")
                Text(title)
                    .font(TypographyTokens.sectionTitle)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(message)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                if let actionTitle, let action {
                    SPARKButton(title: actionTitle, variant: .secondary, action: action)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

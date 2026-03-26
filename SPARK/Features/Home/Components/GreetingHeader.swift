import SwiftUI

struct GreetingHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.inline) {
            Text(title)
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.secondaryText)
            Text(subtitle)
                .font(TypographyTokens.display)
                .foregroundStyle(ColorTokens.primaryText)
                .lineSpacing(2)
        }
    }
}

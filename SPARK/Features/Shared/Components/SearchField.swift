import SwiftUI

struct SearchField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        StudioPanel(style: .quiet, padding: nil) {
            HStack(spacing: SpacingTokens.small) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ColorTokens.tertiaryText)
                TextField(title, text: $text)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
        }
    }
}

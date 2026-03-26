import SwiftUI

struct AutosaveIndicator: View {
    let state: AutosaveState

    var body: some View {
        HStack(spacing: 6) {
            switch state {
            case .idle:
                Image(systemName: "circle")
                    .font(.system(size: 6))
                    .foregroundStyle(ColorTokens.hairline)
                Text("Draft open")
            case .saving:
                ProgressView()
                    .scaleEffect(0.7)
                    .tint(ColorTokens.accent)
                Text("Saving softly")
            case .saved(let message):
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(ColorTokens.success)
                Text(message)
            }
        }
        .font(TypographyTokens.caption)
        .foregroundStyle(ColorTokens.secondaryText)
    }
}

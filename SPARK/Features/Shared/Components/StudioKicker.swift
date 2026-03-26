import SwiftUI

struct StudioKicker: View {
    let title: String
    var tint: Color = ColorTokens.secondaryText

    var body: some View {
        Text(title)
            .font(TypographyTokens.microLabel)
            .tracking(1.1)
            .foregroundStyle(tint)
            .textCase(.uppercase)
    }
}

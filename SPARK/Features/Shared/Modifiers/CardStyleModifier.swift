import SwiftUI

struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        StudioPanel(style: .quiet, padding: SpacingTokens.large) {
            content
        }
    }
}

import SwiftUI

struct SPARKCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        StudioPanel(style: .archival, padding: SpacingTokens.large) {
            content
        }
    }
}

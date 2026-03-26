import SwiftUI

struct SketchToolbar: View {
    var onClear: () -> Void
    var onSave: () -> Void

    var body: some View {
        HStack(spacing: SpacingTokens.small) {
            SPARKButton(title: "Clear", variant: .quiet, action: onClear)
            SPARKButton(title: "Attach sketch", variant: .secondary, action: onSave)
        }
    }
}

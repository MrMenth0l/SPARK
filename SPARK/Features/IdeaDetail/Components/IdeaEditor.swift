import SwiftUI

struct IdeaEditor: View {
    @Binding var title: String
    @Binding var bodyText: String

    var body: some View {
        StudioPanel(style: .focal, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                TextField("Title or first line", text: $title)
                    .font(TypographyTokens.title)
                    .foregroundStyle(ColorTokens.primaryText)

                Rectangle()
                    .fill(ColorTokens.rule.opacity(0.55))
                    .frame(height: 1)

                TextEditor(text: $bodyText)
                    .font(TypographyTokens.editorBody)
                    .foregroundStyle(ColorTokens.primaryText)
                    .frame(minHeight: 320)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
        }
    }
}

import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(TypographyTokens.sectionTitle)
                .foregroundStyle(ColorTokens.primaryText)
            Spacer()
            if let actionTitle, let action {
                Button(action: action) {
                    HStack(spacing: 6) {
                        Text(actionTitle)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

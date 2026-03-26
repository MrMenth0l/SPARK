import SwiftUI

struct CaptureModeSwitcher: View {
    @Binding var selectedMode: CaptureMode

    var body: some View {
        HStack(spacing: SpacingTokens.small) {
            ForEach(CaptureMode.allCases) { mode in
                Button(action: { selectedMode = mode }) {
                    HStack(spacing: 8) {
                        Image(systemName: mode.systemImage)
                        Text(mode.title)
                            .font(TypographyTokens.caption)
                    }
                    .foregroundStyle(selectedMode == mode ? ColorTokens.primaryText : ColorTokens.secondaryText)
                    .padding(.horizontal, SpacingTokens.medium)
                    .padding(.vertical, 10)
                    .background(
                        Capsule(style: .continuous)
                            .fill(selectedMode == mode ? ColorTokens.accentSoft.opacity(0.55) : Color.clear)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(
                                        selectedMode == mode ? ColorTokens.accent.opacity(0.28) : ColorTokens.hairline,
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

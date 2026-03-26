import SwiftUI

struct QuickCaptureStrip: View {
    let preferredMode: CaptureMode
    var onTap: (CaptureMode) -> Void

    var body: some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Composer")
                Text("Move into a fragment immediately. Voice and sketch stay within reach.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)

                HStack(alignment: .center, spacing: SpacingTokens.medium) {
                    Button(action: { onTap(preferredMode) }) {
                        HStack(spacing: SpacingTokens.small) {
                            Image(systemName: preferredMode.systemImage)
                            Text("Begin a fragment")
                                .font(TypographyTokens.bodyEmphasis)
                        }
                        .foregroundStyle(ColorTokens.primaryText)
                        .padding(.horizontal, SpacingTokens.medium)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                                .fill(ColorTokens.page)
                                .overlay(
                                    RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                                        .stroke(ColorTokens.hairline, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpacingTokens.small) {
                            ForEach(CaptureMode.allCases.filter { $0 != preferredMode }) { mode in
                                Button(action: { onTap(mode) }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: mode.systemImage)
                                        Text(mode.title)
                                            .font(TypographyTokens.caption)
                                    }
                                    .foregroundStyle(ColorTokens.secondaryText)
                                    .padding(.horizontal, SpacingTokens.medium)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(Color.clear)
                                            .overlay(
                                                Capsule(style: .continuous)
                                                    .stroke(ColorTokens.hairline, lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
    }
}

import SwiftUI

struct SPARKButton: View {
    enum Variant {
        case primary
        case secondary
        case tertiary
        case quiet
    }

    let title: String
    var systemImage: String?
    var variant: Variant = .primary
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SpacingTokens.small) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(variant == .tertiary ? TypographyTokens.caption : TypographyTokens.action)
            .foregroundStyle(foregroundStyle)
            .padding(.horizontal, SpacingTokens.medium)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: variant == .primary ? .infinity : nil)
        }
        .buttonStyle(SPARKButtonPressStyle(background: AnyView(background)))
    }

    private var foregroundStyle: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary:
            return ColorTokens.primaryText
        case .tertiary:
            return ColorTokens.accentStrong
        case .quiet:
            return ColorTokens.secondaryText
        }
    }

    private var verticalPadding: CGFloat {
        switch variant {
        case .primary, .secondary:
            return 13
        case .tertiary:
            return 6
        case .quiet:
            return 10
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [ColorTokens.accent, ColorTokens.accentStrong],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        case .secondary:
            RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                .fill(ColorTokens.page.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                        .stroke(ColorTokens.hairline, lineWidth: 1)
                )
        case .tertiary:
            RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                .fill(.clear)
        case .quiet:
            RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                .fill(ColorTokens.quietSurface.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                        .stroke(ColorTokens.hairline.opacity(0.7), lineWidth: 1)
                )
        }
    }
}

private struct SPARKButtonPressStyle: ButtonStyle {
    let background: AnyView

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(background.opacity(configuration.isPressed ? 0.92 : 1))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.sparkSubtle, value: configuration.isPressed)
    }
}

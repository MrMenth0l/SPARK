import SwiftUI

struct Chip: View {
    enum Kind {
        case filter
        case tag
        case taxonomy
        case quiet
    }

    let title: String
    var isSelected: Bool
    var kind: Kind = .filter
    var accent: Color = ColorTokens.accent

    var body: some View {
        Text(title)
            .font(TypographyTokens.chip)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                Capsule(style: .continuous)
                    .fill(backgroundColor)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
    }

    private var foregroundColor: Color {
        if isSelected {
            switch kind {
            case .tag, .taxonomy:
                return accent
            case .filter, .quiet:
                return ColorTokens.primaryText
            }
        }
        return kind == .quiet ? ColorTokens.secondaryText : ColorTokens.primaryText
    }

    private var backgroundColor: Color {
        if isSelected {
            switch kind {
            case .filter, .quiet:
                return accent.opacity(0.14)
            case .tag, .taxonomy:
                return accent.opacity(0.12)
            }
        }

        switch kind {
        case .filter:
            return ColorTokens.page.opacity(0.8)
        case .tag:
            return ColorTokens.pageWarm.opacity(0.72)
        case .taxonomy:
            return accent.opacity(0.08)
        case .quiet:
            return .clear
        }
    }

    private var borderColor: Color {
        if isSelected {
            return accent.opacity(kind == .filter ? 0.3 : 0.45)
        }
        switch kind {
        case .filter, .tag:
            return ColorTokens.hairline
        case .taxonomy:
            return accent.opacity(0.2)
        case .quiet:
            return ColorTokens.hairline.opacity(0.5)
        }
    }

    private var borderWidth: CGFloat {
        kind == .quiet && !isSelected ? 0.75 : 1
    }

    private var horizontalPadding: CGFloat {
        kind == .quiet ? 12 : SpacingTokens.medium
    }

    private var verticalPadding: CGFloat {
        kind == .quiet ? 8 : 10
    }
}

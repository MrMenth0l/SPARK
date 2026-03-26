import SwiftUI

enum StudioPanelStyle {
    case focal
    case elevated
    case quiet
    case archival
    case floating
}

enum StudioAccentEdge {
    case top
    case leading
}

struct StudioPanel<Content: View>: View {
    var style: StudioPanelStyle = .quiet
    var accent: Color? = nil
    var accentEdge: StudioAccentEdge = .top
    var cornerRadius: CGFloat? = nil
    var padding: CGFloat? = nil
    @ViewBuilder var content: Content

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius ?? defaultRadius, style: .continuous)

        Group {
            if let padding {
                content
                    .padding(padding)
            } else {
                content
            }
        }
        .background(
            shape
                .fill(fillStyle)
                .overlay(shape.stroke(borderColor, lineWidth: borderWidth))
                .overlay(shape.stroke(Color.white.opacity(innerHighlightOpacity), lineWidth: 0.75))
                .overlay(alignment: accentAlignment) {
                    if let accent {
                        accentBar(accent)
                    }
                }
        )
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowYOffset)
    }

    private var defaultRadius: CGFloat {
        switch style {
        case .focal:
            return RadiusTokens.folio
        case .elevated:
            return RadiusTokens.sheet
        case .quiet:
            return RadiusTokens.card
        case .archival:
            return RadiusTokens.card
        case .floating:
            return RadiusTokens.floating
        }
    }

    private var fillStyle: AnyShapeStyle {
        switch style {
        case .focal:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [ColorTokens.page, ColorTokens.pageWarm],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .elevated:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [ColorTokens.elevatedSurface, Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .quiet:
            return AnyShapeStyle(ColorTokens.quietSurface.opacity(0.82))
        case .archival:
            return AnyShapeStyle(ColorTokens.pageWarm.opacity(0.52))
        case .floating:
            return AnyShapeStyle(ColorTokens.dockSurface)
        }
    }

    private var borderColor: Color {
        switch style {
        case .focal:
            return ColorTokens.hairline.opacity(0.9)
        case .elevated:
            return ColorTokens.hairline.opacity(0.8)
        case .quiet:
            return ColorTokens.hairline.opacity(0.72)
        case .archival:
            return ColorTokens.hairline.opacity(0.58)
        case .floating:
            return ColorTokens.hairline.opacity(0.65)
        }
    }

    private var borderWidth: CGFloat {
        style == .archival ? 0.8 : 1
    }

    private var innerHighlightOpacity: Double {
        switch style {
        case .focal, .elevated, .floating:
            return 0.55
        case .quiet, .archival:
            return 0.35
        }
    }

    private var shadowColor: Color {
        switch style {
        case .focal:
            return ColorTokens.shadow.opacity(0.9)
        case .elevated:
            return ColorTokens.shadow
        case .quiet, .archival:
            return .clear
        case .floating:
            return ColorTokens.shadow.opacity(1.2)
        }
    }

    private var shadowRadius: CGFloat {
        switch style {
        case .focal:
            return 18
        case .elevated:
            return 14
        case .quiet, .archival:
            return 0
        case .floating:
            return 20
        }
    }

    private var shadowYOffset: CGFloat {
        switch style {
        case .focal:
            return 10
        case .elevated:
            return 8
        case .quiet, .archival:
            return 0
        case .floating:
            return 10
        }
    }

    private var accentAlignment: Alignment {
        switch accentEdge {
        case .top:
            return .top
        case .leading:
            return .leading
        }
    }

    @ViewBuilder
    private func accentBar(_ accent: Color) -> some View {
        switch accentEdge {
        case .top:
            Rectangle()
                .fill(accent.opacity(0.9))
                .frame(height: 2)
                .padding(.horizontal, 18)
        case .leading:
            Rectangle()
                .fill(accent.opacity(0.9))
                .frame(width: 3)
                .padding(.vertical, 18)
        }
    }
}

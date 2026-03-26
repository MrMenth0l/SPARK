import SwiftUI

struct StimulusMediaView: View {
    let media: StimulusMedia?
    var height: CGFloat = 180
    var cornerRadius: CGFloat = 20
    var accent: Color = ColorTokens.accentWash

    var body: some View {
        Group {
            if let media {
                content(for: media)
            } else {
                placeholder(symbol: "photo")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(ColorTokens.cardBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func content(for media: StimulusMedia) -> some View {
        switch media.storage {
        case .remoteURL(let urlString):
            if let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        placeholder(symbol: fallbackSymbol(for: media.role))
                    }
                }
            } else {
                placeholder(symbol: fallbackSymbol(for: media.role))
            }
        case .bundleAsset(let name):
            Image(name)
                .resizable()
                .scaledToFill()
        case .systemSymbol(let symbolName):
            placeholder(symbol: symbolName)
        }
    }

    private func placeholder(symbol: String) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    ColorTokens.page.opacity(0.95),
                    accent.opacity(0.38)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: symbol)
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(ColorTokens.primaryText.opacity(0.55))
        }
    }

    private func fallbackSymbol(for role: StimulusMedia.Role) -> String {
        switch role {
        case .hero, .supporting:
            return "photo"
        case .left:
            return "rectangle.leadinghalf.filled"
        case .right:
            return "rectangle.trailinghalf.filled"
        }
    }
}

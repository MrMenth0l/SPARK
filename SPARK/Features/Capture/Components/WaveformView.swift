import SwiftUI

struct WaveformView: View {
    let isAnimating: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(isAnimating ? ColorTokens.accent : ColorTokens.accentSoft.opacity(0.7))
                    .frame(width: 6, height: isAnimating ? CGFloat((index % 4) + 2) * 12 : 16)
                    .animation(
                        isAnimating ? .easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.04) : .default,
                        value: isAnimating
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTokens.medium)
    }
}

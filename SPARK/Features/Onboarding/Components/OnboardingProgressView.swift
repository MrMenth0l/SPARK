import SwiftUI

struct OnboardingProgressView: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(ColorTokens.pageWarm.opacity(0.9))
                    .overlay(Capsule().stroke(ColorTokens.hairline, lineWidth: 1))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [ColorTokens.accentSoft, ColorTokens.accent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}

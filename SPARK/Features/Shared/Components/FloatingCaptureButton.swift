import SwiftUI

struct FloatingCaptureButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
                .background(
                    RoundedRectangle(cornerRadius: RadiusTokens.floating, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [ColorTokens.accent, ColorTokens.accentStrong],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: RadiusTokens.floating, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
        .shadow(color: ColorTokens.shadow.opacity(1.1), radius: 16, x: 0, y: 10)
    }
}

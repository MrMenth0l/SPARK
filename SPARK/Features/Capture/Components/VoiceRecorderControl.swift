import SwiftUI

struct VoiceRecorderControl: View {
    let isRecording: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 84, height: 84)
                .background(
                    Circle()
                        .fill(isRecording ? ColorTokens.warning : ColorTokens.accentStrong)
                        .overlay(Circle().stroke(Color.white.opacity(0.14), lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
        .shadow(color: ColorTokens.shadow, radius: 16, x: 0, y: 10)
    }
}

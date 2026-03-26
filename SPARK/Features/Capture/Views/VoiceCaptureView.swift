import SwiftUI

struct VoiceCaptureView: View {
    @Bindable var viewModel: VoiceCaptureViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            StudioKicker(title: "Voice material")
            StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
                VStack(spacing: SpacingTokens.large) {
                    WaveformView(isAnimating: viewModel.isRecording && !viewModel.isPaused)
                    Text(viewModel.elapsedTime.formatted(.number.precision(.fractionLength(0))) + "s")
                        .font(TypographyTokens.sectionTitle)
                        .foregroundStyle(ColorTokens.primaryText)

                    VoiceRecorderControl(isRecording: viewModel.isRecording) {
                        if viewModel.isRecording {
                            viewModel.finishRecording()
                        } else {
                            Task { await viewModel.startRecording() }
                        }
                    }

                    if viewModel.isRecording {
                        SPARKButton(title: viewModel.isPaused ? "Resume" : "Pause", variant: .secondary, action: viewModel.togglePause)
                    }
                }
            }

            if viewModel.currentAttachment != nil || viewModel.isRecording {
                StudioPanel(style: .archival, padding: SpacingTokens.medium) {
                    VStack(alignment: .leading, spacing: SpacingTokens.small) {
                        StudioKicker(title: "Transcription")
                        TextEditor(text: $viewModel.transcription)
                            .font(TypographyTokens.editorBody)
                            .foregroundStyle(ColorTokens.primaryText)
                            .frame(minHeight: 130)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(TypographyTokens.footnote)
                    .foregroundStyle(ColorTokens.warning)
            }
        }
    }
}

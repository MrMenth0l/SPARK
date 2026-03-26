import Foundation
import Observation

@Observable
@MainActor
final class VoiceCaptureViewModel {
    private let voiceCaptureService: any VoiceCaptureService
    private let captureViewModel: CaptureViewModel

    var transcription: String = ""
    var errorMessage: String?

    init(container: AppContainer, captureViewModel: CaptureViewModel) {
        self.voiceCaptureService = container.services.voiceCaptureService
        self.captureViewModel = captureViewModel
    }

    var isRecording: Bool { voiceCaptureService.isRecording }
    var isPaused: Bool { voiceCaptureService.isPaused }
    var elapsedTime: TimeInterval { voiceCaptureService.elapsedTime }
    var currentAttachment: VoiceAttachment? { voiceCaptureService.currentAttachment }

    func startRecording() async {
        do {
            try await voiceCaptureService.startRecording()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func togglePause() {
        do {
            try voiceCaptureService.togglePause()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func finishRecording() {
        do {
            if let attachment = try voiceCaptureService.finishRecording(transcription: transcription.isBlank ? nil : transcription) {
                captureViewModel.attachVoice(attachment)
            }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func discard() {
        voiceCaptureService.discardRecording()
        transcription = ""
    }
}

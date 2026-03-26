import Foundation
import Observation
import PencilKit

@Observable
@MainActor
final class SketchCaptureViewModel {
    private let sketchService: any SketchService
    private let captureViewModel: CaptureViewModel

    var drawing = PKDrawing()
    var note = ""
    var errorMessage: String?

    init(container: AppContainer, captureViewModel: CaptureViewModel) {
        self.sketchService = container.services.sketchService
        self.captureViewModel = captureViewModel
    }

    func saveCurrentSketch() {
        do {
            let attachment = try sketchService.saveDrawing(drawing, note: note.isBlank ? nil : note)
            captureViewModel.attachSketch(attachment)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

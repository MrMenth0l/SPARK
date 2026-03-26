import Foundation
import Observation

@Observable
@MainActor
final class WriteCaptureViewModel {
    private let captureViewModel: CaptureViewModel

    init(captureViewModel: CaptureViewModel) {
        self.captureViewModel = captureViewModel
    }

    var text: String {
        get { captureViewModel.text }
        set { captureViewModel.updateText(newValue) }
    }
}

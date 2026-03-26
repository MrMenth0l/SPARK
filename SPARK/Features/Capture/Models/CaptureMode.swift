import Foundation

enum CaptureMode: String, Codable, CaseIterable, Identifiable, Hashable {
    case write
    case voice
    case sketch

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var systemImage: String {
        switch self {
        case .write:
            return "pencil"
        case .voice:
            return "waveform"
        case .sketch:
            return "scribble.variable"
        }
    }
}

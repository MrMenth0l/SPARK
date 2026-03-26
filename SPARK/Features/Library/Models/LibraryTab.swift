import Foundation

enum LibraryTab: String, CaseIterable, Identifiable {
    case overview
    case ideas
    case sparks
    case drafts

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview:
            return "Overview"
        case .ideas:
            return "Ideas"
        case .sparks:
            return "Stimuli"
        case .drafts:
            return "Drafts"
        }
    }
}

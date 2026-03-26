import Foundation

struct LibraryFilterState: Equatable {
    enum SortOption: String, CaseIterable, Identifiable {
        case recent
        case oldest
        case mostRevisited
        case unfinished

        var id: String { rawValue }

        var title: String {
            switch self {
            case .recent:
                return "Recent"
            case .oldest:
                return "Oldest"
            case .mostRevisited:
                return "Most revisited"
            case .unfinished:
                return "Unfinished"
            }
        }
    }

    var sortOption: SortOption = .recent
    var selectedTag: String?
    var withSourceStimulusOnly = false
    var hasVoiceOnly = false
    var hasSketchOnly = false
    var unfinishedOnly = false
}

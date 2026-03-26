import Foundation

enum AppTab: String, CaseIterable, Hashable, Identifiable {
    case home
    case discover
    case library

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .discover:
            return "Discover"
        case .library:
            return "Library"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .discover:
            return "square.grid.2x2"
        case .library:
            return "books.vertical"
        }
    }
}

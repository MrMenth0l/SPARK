import SwiftUI

enum ScreenPaddingStyle {
    case airy
    case standard
    case archive

    var horizontalInset: CGFloat {
        switch self {
        case .airy:
            return SpacingTokens.airyPageInset
        case .standard:
            return SpacingTokens.pageInset
        case .archive:
            return SpacingTokens.archiveInset
        }
    }
}

struct ScreenPaddingModifier: ViewModifier {
    var style: ScreenPaddingStyle = .standard

    func body(content: Content) -> some View {
        content.padding(.horizontal, style.horizontalInset)
    }
}

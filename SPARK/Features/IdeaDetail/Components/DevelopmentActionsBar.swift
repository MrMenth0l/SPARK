import SwiftUI

struct DevelopmentActionsBar: View {
    let isLoading: Bool
    var onTap: (DevelopmentAction) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTokens.small) {
                ForEach(DevelopmentAction.allCases) { action in
                    Button(action: { onTap(action) }) {
                        Chip(title: action.title, isSelected: false, kind: .filter, accent: ColorTokens.accent)
                    }
                    .buttonStyle(.plain)
                    .disabled(isLoading)
                }
            }
        }
    }
}

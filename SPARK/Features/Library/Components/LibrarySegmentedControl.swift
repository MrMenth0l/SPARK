import SwiftUI

struct LibrarySegmentedControl: View {
    @Binding var selectedTab: LibraryTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTokens.small) {
                ForEach([LibraryTab.ideas, .sparks, .drafts], id: \.self) { tab in
                    Button(action: { selectedTab = tab }) {
                        Chip(title: tab.title, isSelected: selectedTab == tab, kind: .filter, accent: ColorTokens.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

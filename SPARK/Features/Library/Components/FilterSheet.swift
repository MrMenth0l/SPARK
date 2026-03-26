import SwiftUI

struct FilterSheet: View {
    @Binding var filterState: LibraryFilterState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SpacingTokens.large) {
                    VStack(alignment: .leading, spacing: SpacingTokens.small) {
                        Text("Refine archive")
                            .font(TypographyTokens.sectionTitle)
                            .foregroundStyle(ColorTokens.primaryText)
                        Text("Narrow the archive without turning it into a dashboard.")
                            .font(TypographyTokens.note)
                            .foregroundStyle(ColorTokens.secondaryText)
                    }

                    StudioPanel(style: .quiet, padding: SpacingTokens.large) {
                        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                            StudioKicker(title: "Sort")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: SpacingTokens.small) {
                                    ForEach(LibraryFilterState.SortOption.allCases) { option in
                                        Button(action: { filterState.sortOption = option }) {
                                            Chip(
                                                title: option.title,
                                                isSelected: filterState.sortOption == option,
                                                kind: .filter,
                                                accent: ColorTokens.accent
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }

                    StudioPanel(style: .quiet, padding: SpacingTokens.large) {
                        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                            StudioKicker(title: "Filters")
                            filterToggle("With source stimulus only", isOn: $filterState.withSourceStimulusOnly)
                            filterToggle("Has voice", isOn: $filterState.hasVoiceOnly)
                            filterToggle("Has sketch", isOn: $filterState.hasSketchOnly)
                            filterToggle("Unfinished only", isOn: $filterState.unfinishedOnly)
                        }
                    }
                }
                .modifier(ScreenPaddingModifier(style: .airy))
                .padding(.vertical, SpacingTokens.pageTop)
            }
            .sparkScreenBackground()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func filterToggle(_ title: String, isOn: Binding<Bool>) -> some View {
        Button(action: { isOn.wrappedValue.toggle() }) {
            HStack {
                Text(title)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                Spacer()
                Image(systemName: isOn.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isOn.wrappedValue ? ColorTokens.accent : ColorTokens.hairline)
            }
        }
        .buttonStyle(.plain)
    }
}

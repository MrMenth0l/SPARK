import SwiftUI

struct DiscoverView: View {
    @Environment(RootCoordinator.self) private var coordinator
    @State private var viewModel: DiscoverViewModel
    @State private var selectedStimulus: StimulusRecord?
    @State private var isFilterPresented = false

    init(container: AppContainer) {
        _viewModel = State(initialValue: DiscoverViewModel(container: container))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SpacingTokens.section) {
                SparkFeedHeader()
                filterSummary

                if viewModel.isLoading {
                    DiscoverLoadingState()
                } else if viewModel.filteredStimuli.isEmpty {
                    EmptyStateView(
                        title: "No stimuli in this room",
                        message: "Clear the refinement and the studio opens back up."
                    )
                } else {
                    if let highlightedStimulus = viewModel.highlightedStimulus {
                        DiscoverLeadCard(
                            record: highlightedStimulus,
                            onSave: { viewModel.toggleSave(highlightedStimulus) },
                            onRespond: {
                                coordinator.openCapture(mode: .write, stimulusID: highlightedStimulus.id, relation: .respondingTo)
                            },
                            onBuild: {
                                coordinator.openCapture(mode: .write, stimulusID: highlightedStimulus.id, relation: .builtFrom)
                            },
                            onOpen: { selectedStimulus = highlightedStimulus }
                        )
                    }

                    ForEach(viewModel.familySections) { section in
                        DiscoverFamilyShelf(
                            section: section,
                            onSave: viewModel.toggleSave,
                            onRespond: { stimulus in
                                coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .respondingTo)
                            },
                            onBuild: { stimulus in
                                coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .builtFrom)
                            },
                            onOpen: { stimulus in
                                selectedStimulus = stimulus
                            }
                        )
                    }
                }
            }
            .modifier(ScreenPaddingModifier(style: .airy))
            .padding(.vertical, SpacingTokens.pageTop)
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .sheet(item: $selectedStimulus) { stimulus in
            StimulusDetailSheet(
                record: stimulus,
                onSave: { viewModel.toggleSave(stimulus) },
                onRespond: {
                    selectedStimulus = nil
                    coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .respondingTo)
                },
                onBuild: {
                    selectedStimulus = nil
                    coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .builtFrom)
                }
            )
            .presentationDetents([.large])
        }
        .sheet(isPresented: $isFilterPresented) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: SpacingTokens.large) {
                        Text("Refine the room")
                            .font(TypographyTokens.sectionTitle)
                            .foregroundStyle(ColorTokens.primaryText)
                        Text("Use a family or domain only when you want the room to narrow on purpose.")
                            .font(TypographyTokens.body)
                            .foregroundStyle(ColorTokens.secondaryText)
                        DiscoverFilterBar(state: $viewModel.filterState)
                        if viewModel.hasActiveFilters {
                            SPARKButton(title: "Clear refinement", variant: .secondary, action: viewModel.clearFilters)
                        }
                    }
                    .modifier(ScreenPaddingModifier())
                    .padding(.vertical, SpacingTokens.xLarge)
                }
                .sparkScreenBackground()
                .modifier(QuietNavigationBarModifier())
            }
            .presentationDetents([.medium])
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var filterSummary: some View {
        StudioPanel(style: .archival, padding: SpacingTokens.medium) {
            HStack(alignment: .center, spacing: SpacingTokens.small) {
                if viewModel.hasActiveFilters {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpacingTokens.small) {
                            ForEach(viewModel.activeFilterLabels, id: \.self) { label in
                                Chip(title: label, isSelected: true, kind: .filter, accent: ColorTokens.accent)
                            }
                        }
                    }

                    Button("Clear", action: viewModel.clearFilters)
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                } else {
                    Text("Browse the room by family, then narrow only when you need it.")
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                }

                Spacer()

                Button(action: { isFilterPresented = true }) {
                    Label("Refine", systemImage: "slider.horizontal.3")
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct DiscoverLoadingState: View {
    var body: some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Opening the wider studio")
                Text("Gathering a richer set of artifacts, patterns, contrasts, and collisions.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                ProgressView()
                    .tint(ColorTokens.accent)
            }
        }
    }
}

private struct DiscoverLeadCard: View {
    let record: StimulusRecord
    var onSave: () -> Void
    var onRespond: () -> Void
    var onBuild: () -> Void
    var onOpen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            StudioKicker(title: "Start with one strong object", tint: ColorTokens.accent)

            StimulusCard(
                record: record,
                onSave: onSave,
                onRespond: onRespond,
                onBuild: onBuild,
                onOpen: onOpen
            )
        }
    }
}

private struct DiscoverFamilyShelf: View {
    let section: DiscoverFamilySectionModel
    var onSave: (StimulusRecord) -> Void
    var onRespond: (StimulusRecord) -> Void
    var onBuild: (StimulusRecord) -> Void
    var onOpen: (StimulusRecord) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 6) {
                Text(section.family.title)
                    .font(TypographyTokens.sectionTitle)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(section.family.shortDescription)
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: SpacingTokens.medium) {
                    ForEach(section.stimuli) { stimulus in
                        StimulusCard(
                            record: stimulus,
                            onSave: { onSave(stimulus) },
                            onRespond: { onRespond(stimulus) },
                            onBuild: { onBuild(stimulus) },
                            onOpen: { onOpen(stimulus) }
                        )
                        .frame(width: section.family.shelfCardWidth)
                    }
                }
                .padding(.trailing, SpacingTokens.medium)
            }
        }
    }
}

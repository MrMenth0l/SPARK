import SwiftUI

struct LibraryView: View {
    @Environment(RootCoordinator.self) private var coordinator
    @State private var viewModel: LibraryViewModel
    @State private var isFilterPresented = false

    init(container: AppContainer) {
        _viewModel = State(initialValue: LibraryViewModel(container: container))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SpacingTokens.section) {
                header

                if viewModel.selectedTab == .overview {
                    overviewContent
                } else {
                    browseContent
                }
            }
            .modifier(ScreenPaddingModifier(style: .archive))
            .padding(.vertical, SpacingTokens.pageTop)
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .sheet(isPresented: $isFilterPresented) {
            FilterSheet(filterState: $viewModel.filterState)
                .presentationDetents([.medium])
        }
        .onAppear {
            viewModel.load()
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Library")
                    .font(TypographyTokens.display)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(viewModel.selectedTab == .overview
                     ? "A quieter archive for return, continuation, and kept stimuli."
                     : "Browse the archive without letting the archive become the whole experience.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
            }
            Spacer()

            if viewModel.selectedTab == .overview {
                Button("Browse") {
                    viewModel.enterBrowse(.ideas)
                }
                .font(TypographyTokens.caption)
                .foregroundStyle(ColorTokens.accent)
                .buttonStyle(.plain)
            } else {
                Button("Overview") {
                    viewModel.returnToOverview()
                }
                .font(TypographyTokens.caption)
                .foregroundStyle(ColorTokens.accent)
                .buttonStyle(.plain)
            }

            Button {
                coordinator.openCapture(mode: .write)
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(ColorTokens.primaryText)
                }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var overviewContent: some View {
        if !viewModel.resurfacedItems.isEmpty {
            ReturnToThisSection(items: viewModel.resurfacedItems, onOpen: openResurfaced, onDismiss: viewModel.dismissResurfaced)
        }

        if !viewModel.continuationIdeas.isEmpty || !viewModel.continuationDrafts.isEmpty {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                SectionHeader(title: "Continue", actionTitle: "Browse all") {
                    viewModel.enterBrowse(.drafts)
                }

                ForEach(viewModel.continuationIdeas) { idea in
                    IdeaRowCard(idea: idea) {
                        coordinator.openIdeaDetail(idea.id)
                    }
                }

                ForEach(viewModel.continuationDrafts) { draft in
                    DraftRowCard(draft: draft) {
                        coordinator.openCapture(
                            mode: draft.mode,
                            stimulusID: draft.primaryStimulusID,
                            relation: draft.sourceStimulusLink?.relation,
                            draftID: draft.id
                        )
                    }
                }
            }
        }

        if !viewModel.recentIdeas.isEmpty {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                SectionHeader(title: "Recent ideas", actionTitle: "View all") {
                    viewModel.enterBrowse(.ideas)
                }
                ForEach(viewModel.recentIdeas) { idea in
                    IdeaRowCard(idea: idea) {
                        coordinator.openIdeaDetail(idea.id)
                    }
                }
            }
        }

        if !viewModel.keptStimuliPreview.isEmpty {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                SectionHeader(title: "Kept stimuli", actionTitle: "View all") {
                    viewModel.enterBrowse(.sparks)
                }
                ForEach(viewModel.keptStimuliPreview) { stimulus in
                    SavedStimulusRow(
                        record: stimulus,
                        onOpen: { coordinator.push(.stimulusDetail(stimulus.id)) },
                        onRespond: { coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .respondingTo) },
                        onBuild: { coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .builtFrom) }
                    )
                }
            }
        }

        if !viewModel.hasArchiveContent {
            EmptyStateView(
                title: "Your archive will grow with you",
                message: "Ideas you keep, drafts you pause, and stimuli you want to return to will settle here quietly."
            )
        }
    }

    private var browseContent: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            LibrarySegmentedControl(selectedTab: $viewModel.selectedTab)

            LibrarySearchBar(query: $viewModel.searchQuery)
                .onChange(of: viewModel.searchQuery) { _, _ in
                    viewModel.refreshSearch()
                }

            StudioPanel(style: .archival, padding: SpacingTokens.medium) {
                HStack {
                    Button {
                        isFilterPresented = true
                    } label: {
                        Label("Refine", systemImage: "slider.horizontal.3")
                            .font(TypographyTokens.caption)
                            .foregroundStyle(ColorTokens.accent)
                    }
                    .buttonStyle(.plain)

                    if viewModel.hasActiveFilters {
                        Button("Clear filters") {
                            viewModel.filterState = LibraryFilterState()
                            viewModel.load()
                        }
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
            }

            switch viewModel.selectedTab {
            case .overview:
                EmptyView()
            case .ideas:
                if viewModel.filteredIdeas.isEmpty {
                    EmptyStateView(title: "No ideas here", message: "Try a different search or return to the overview.")
                } else {
                    ForEach(viewModel.filteredIdeas) { idea in
                        IdeaRowCard(idea: idea) {
                            coordinator.openIdeaDetail(idea.id)
                        }
                    }
                }
            case .sparks:
                if viewModel.filteredStimuli.isEmpty {
                    EmptyStateView(title: "No kept stimuli", message: "Save a stimulus from Home or Discover to keep it within reach.")
                } else {
                    ForEach(viewModel.filteredStimuli) { stimulus in
                        SavedStimulusRow(
                            record: stimulus,
                            onOpen: { coordinator.push(.stimulusDetail(stimulus.id)) },
                            onRespond: { coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .respondingTo) },
                            onBuild: { coordinator.openCapture(mode: .write, stimulusID: stimulus.id, relation: .builtFrom) }
                        )
                    }
                }
            case .drafts:
                if viewModel.filteredDrafts.isEmpty {
                    EmptyStateView(title: "No drafts waiting", message: "Fragments you pause will stay here until you want another pass.")
                } else {
                    ForEach(viewModel.filteredDrafts) { draft in
                        DraftRowCard(draft: draft) {
                            coordinator.openCapture(
                                mode: draft.mode,
                                stimulusID: draft.primaryStimulusID,
                                relation: draft.sourceStimulusLink?.relation,
                                draftID: draft.id
                            )
                        }
                    }
                }
            }
        }
    }

    private func openResurfaced(_ item: ResurfacedItem) {
        switch item.kind {
        case .idea(let ideaID):
            coordinator.openIdeaDetail(ideaID)
        case .stimulus(let stimulusID):
            coordinator.push(.stimulusDetail(stimulusID))
        }
    }
}

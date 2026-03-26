import SwiftUI

struct HomeView: View {
    @Environment(RootCoordinator.self) private var coordinator
    @State private var viewModel: HomeViewModel

    init(container: AppContainer) {
        _viewModel = State(initialValue: HomeViewModel(container: container))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SpacingTokens.section) {
                GreetingHeader(title: viewModel.greeting, subtitle: viewModel.supportLine)

                if viewModel.state.isLoading {
                    HomeLoadingState()
                } else {
                    if let featuredStimulus = viewModel.featuredStimulus {
                        FeaturedStimulusCard(
                            record: featuredStimulus,
                            onOpen: { coordinator.push(.stimulusDetail(featuredStimulus.id)) },
                            onSave: { viewModel.toggleSave(featuredStimulus) },
                            onRespond: {
                                coordinator.openCapture(mode: .write, stimulusID: featuredStimulus.id, relation: .respondingTo)
                            },
                            onBuild: {
                                coordinator.openCapture(mode: .write, stimulusID: featuredStimulus.id, relation: .builtFrom)
                            }
                        )
                    } else {
                        HomeFallbackCard {
                            coordinator.selectedTab = .discover
                        }
                    }

                    QuickCaptureStrip(preferredMode: viewModel.profile?.preferredCaptureMode ?? .write) { mode in
                        coordinator.openCapture(mode: mode)
                    }

                    if let continueIdea = viewModel.continueIdea {
                        ContinueThinkingCard(idea: continueIdea) {
                            coordinator.openIdeaDetail(continueIdea.id)
                        }
                    }

                    if let resurfacedItem = viewModel.resurfacedItem {
                        ReturnToThisCard(
                            item: resurfacedItem,
                            onOpen: { openResurfacedItem(resurfacedItem) },
                            onBuild: { buildFromResurfacedItem(resurfacedItem) },
                            onDismiss: viewModel.dismissResurfacedItem
                        )
                    }

                    if !viewModel.todayStimuli.isEmpty {
                        DiscoverDoorway(
                            families: Array(Set(viewModel.todayStimuli.map(\.family))).sorted { $0.title < $1.title },
                            rhythm: viewModel.profile?.creativeRhythm ?? .both
                        ) {
                            coordinator.selectedTab = .discover
                        }
                    }
                }
            }
            .modifier(ScreenPaddingModifier(style: .airy))
            .padding(.vertical, SpacingTokens.pageTop)
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .navigationTitle("")
        .task {
            await viewModel.load()
        }
    }

    private func openResurfacedItem(_ item: ResurfacedItem) {
        switch item.kind {
        case .idea(let ideaID):
            coordinator.openIdeaDetail(ideaID)
        case .stimulus(let stimulusID):
            coordinator.push(.stimulusDetail(stimulusID))
        }
    }

    private func buildFromResurfacedItem(_ item: ResurfacedItem) {
        switch item.kind {
        case .idea(let ideaID):
            coordinator.openIdeaDetail(ideaID)
        case .stimulus(let stimulusID):
            coordinator.openCapture(mode: .write, stimulusID: stimulusID, relation: .builtFrom)
        }
    }
}

private struct HomeLoadingState: View {
    var body: some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Preparing today’s room")
                Text("Curating one strong stimulus and a quieter path back into your own thinking.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                ProgressView()
                    .tint(ColorTokens.accent)
            }
        }
    }
}

private struct HomeFallbackCard: View {
    var onDiscover: () -> Void

    var body: some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "The room is quiet right now")
                Text("Step into Discover for a wider set of stimuli while Home resets around one stronger beginning.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
                SPARKButton(title: "Open Discover", variant: .secondary, action: onDiscover)
            }
        }
    }
}

private struct DiscoverDoorway: View {
    let families: [StimulusFamily]
    let rhythm: CreativeRhythm
    var action: () -> Void

    private var summary: String {
        switch rhythm {
        case .dailySparks:
            return "There is a wider room available when you want more range."
        case .freeExplore:
            return "The wider studio is ready whenever you want to browse by family."
        case .both:
            return "A wider room is waiting when you want to range beyond today’s lead."
        }
    }

    var body: some View {
        StudioPanel(style: .archival, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Discover")
                Text(summary)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                if !families.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpacingTokens.small) {
                            ForEach(families, id: \.self) { family in
                                Chip(title: family.title, isSelected: false, kind: .taxonomy, accent: family.accentColor)
                            }
                        }
                    }
                }
                Button(action: action) {
                    HStack(spacing: 6) {
                        Text("Explore the wider room")
                        Image(systemName: "arrow.right")
                    }
                    .font(TypographyTokens.caption)
                    .foregroundStyle(ColorTokens.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

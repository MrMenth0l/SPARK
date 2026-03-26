import SwiftUI

struct RootView: View {
    @Environment(AppContainer.self) private var container
    @Environment(RootCoordinator.self) private var coordinator

    @State private var currentProfile: UserProfile?
    @State private var isReady = false

    var body: some View {
        @Bindable var coordinator = coordinator

        NavigationStack(path: Binding(
            get: { coordinator.navigationState.path },
            set: { coordinator.navigationState.path = $0 }
        )) {
            Group {
                if !isReady {
                    LoadingStateView()
                } else if currentProfile?.onboardingCompleted != true {
                    OnboardingContainerView(container: container) { profile in
                        currentProfile = profile
                    }
                } else {
                    mainShell
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .ideaDetail(let ideaID):
                    IdeaDetailView(container: container, ideaID: ideaID)
                case .capture(let mode, let stimulusID, let relation, let draftID):
                    CaptureView(
                        container: container,
                        initialMode: mode,
                        stimulusID: stimulusID,
                        relation: relation,
                        draftID: draftID
                    )
                case .stimulusDetail(let stimulusID):
                    StimulusDetailLoaderView(container: container, stimulusID: stimulusID)
                case .onboarding:
                    OnboardingContainerView(container: container) { profile in
                        currentProfile = profile
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { coordinator.presentedStimulusID != nil },
            set: { isPresented in
                if !isPresented {
                    coordinator.dismissStimulusDetail()
                }
            }
        )) {
            if let stimulusID = coordinator.presentedStimulusID {
                NavigationStack {
                    StimulusDetailLoaderView(container: container, stimulusID: stimulusID)
                }
                .presentationDetents([.large])
            }
        }
        .fullScreenCover(item: Binding(
            get: { coordinator.presentedCaptureContext },
            set: { context in
                if context == nil {
                    coordinator.dismissCapture()
                } else {
                    coordinator.presentedCaptureContext = context
                }
            }
        )) { context in
            NavigationStack {
                CaptureView(
                    container: container,
                    initialMode: context.mode,
                    stimulusID: context.stimulusID,
                    relation: context.relation,
                    draftID: context.draftID
                )
            }
        }
        .task {
            if !isReady {
                currentProfile = try? container.services.onboardingService.currentProfile()
                isReady = true
            }
        }
    }

    private var mainShell: some View {
        @Bindable var coordinator = coordinator

        return TabView(selection: $coordinator.selectedTab) {
            HomeView(container: container)
                .tabItem { EmptyView() }
                .tag(AppTab.home)

            DiscoverView(container: container)
                .tabItem { EmptyView() }
                .tag(AppTab.discover)

            LibraryView(container: container)
                .tabItem { EmptyView() }
                .tag(AppTab.library)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            SparkPrimaryTabBar(selectedTab: $coordinator.selectedTab) {
                coordinator.openCapture(mode: currentProfile?.preferredCaptureMode ?? .write)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

private struct SparkPrimaryTabBar: View {
    @Binding var selectedTab: AppTab
    var onCompose: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            StudioPanel(style: .floating, padding: nil) {
                Color.clear
                    .frame(height: 78)
            }
            .padding(.top, 22)

            HStack(spacing: SpacingTokens.small) {
                tabButton(.home)
                tabButton(.discover)
                Spacer(minLength: 74)
                tabButton(.library)
            }
            .padding(.horizontal, SpacingTokens.large)
            .padding(.top, 22)
            .frame(height: 100, alignment: .top)

            FloatingCaptureButton(action: onCompose)
        }
        .padding(.horizontal, SpacingTokens.medium)
        .padding(.top, SpacingTokens.medium)
        .padding(.bottom, SpacingTokens.small)
        .background(Color.clear)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 6) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 17, weight: .semibold))
                Text(tab.title)
                    .font(TypographyTokens.caption)
            }
            .foregroundStyle(selectedTab == tab ? ColorTokens.primaryText : ColorTokens.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                ZStack(alignment: .bottom) {
                    Capsule(style: .continuous)
                        .fill(selectedTab == tab ? ColorTokens.page.opacity(0.85) : .clear)
                    Capsule(style: .continuous)
                        .fill(selectedTab == tab ? ColorTokens.accentSoft.opacity(0.2) : .clear)
                    if selectedTab == tab {
                        Capsule(style: .continuous)
                            .fill(ColorTokens.accent)
                            .frame(height: 2)
                            .padding(.horizontal, 18)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

private struct StimulusDetailLoaderView: View {
    @Environment(RootCoordinator.self) private var coordinator
    let container: AppContainer
    let stimulusID: UUID
    @State private var record: StimulusRecord?

    var body: some View {
        Group {
            if let record {
                StimulusDetailSheet(
                    record: record,
                    onSave: {
                        try? container.services.stimulusRepository.setSaved(!record.isSaved, for: record.id)
                        self.record = try? container.services.stimulusRepository.record(id: record.id)
                    },
                    onRespond: {
                        coordinator.dismissStimulusDetail()
                        coordinator.openCapture(mode: .write, stimulusID: record.id, relation: .respondingTo)
                    },
                    onBuild: {
                        coordinator.dismissStimulusDetail()
                        coordinator.openCapture(mode: .write, stimulusID: record.id, relation: .builtFrom)
                    }
                )
            } else {
                LoadingStateView(message: "Loading stimulus...")
            }
        }
        .task {
            try? container.services.stimulusRepository.markViewed(stimulusID)
            record = try? container.services.stimulusRepository.record(id: stimulusID)
        }
    }
}

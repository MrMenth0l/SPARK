import SwiftUI

struct IdeaDetailView: View {
    @Environment(RootCoordinator.self) private var coordinator
    @State private var viewModel: IdeaDetailViewModel
    @State private var isShapeExpanded = false
    @State private var isMaterialExpanded = true
    @State private var isDetailsExpanded = false

    init(container: AppContainer, ideaID: UUID) {
        _viewModel = State(initialValue: IdeaDetailViewModel(container: container, ideaID: ideaID))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.state.isLoading {
                LoadingStateView(message: "Opening idea...")
            } else if let idea = viewModel.idea {
                VStack(alignment: .leading, spacing: SpacingTokens.section) {
                    pageIntro(idea)

                    if let sourceStimulus = viewModel.sourceStimulus {
                        SourceStimulusBlock(record: sourceStimulus, isCompressed: !idea.body.isBlank) {
                            coordinator.push(.stimulusDetail(sourceStimulus.id))
                        }
                    }

                    IdeaEditor(
                        title: Binding(
                            get: { idea.title ?? "" },
                            set: viewModel.updateTitle
                        ),
                        bodyText: Binding(
                            get: { idea.body },
                            set: viewModel.updateBody
                        )
                    )

                    shapeSection

                    if let suggestion = viewModel.state.suggestion {
                        suggestionCard(suggestion)
                    }

                    if !idea.attachments.isEmpty {
                        collapsibleSection(
                            title: "Material",
                            subtitle: "Recorded notes and sketches that still belong to this page.",
                            isExpanded: $isMaterialExpanded
                        ) {
                            if isMaterialExpanded {
                                AttachmentsSection(attachments: idea.attachments)
                            }
                        }
                    }

                    collapsibleSection(
                        title: "Details",
                        subtitle: "Themes and lens stay light so the page can keep breathing.",
                        isExpanded: $isDetailsExpanded
                    ) {
                        if isDetailsExpanded {
                            VStack(alignment: .leading, spacing: SpacingTokens.large) {
                                TagPicker(tags: idea.tags, onAdd: viewModel.addTag, onRemove: viewModel.removeTag)
                                ContextMarkerPicker(selectedMarker: idea.contextMarker, onSelect: viewModel.setContextMarker)
                            }
                        }
                    }

                    RelatedIdeasSection(ideas: viewModel.relatedIdeas) { relatedIdea in
                        coordinator.openIdeaDetail(relatedIdea.id)
                    }
                }
                .modifier(ScreenPaddingModifier(style: .airy))
                .padding(.vertical, SpacingTokens.pageTop)
            }
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .navigationTitle(viewModel.idea?.resolvedTitle ?? "Idea")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.idea?.isFavorite == true ? "bookmark.fill" : "bookmark")
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }

    private func pageIntro(_ idea: IdeaSheet) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            StudioKicker(title: "Living page")
            Text(idea.isUnfinished ? "This thought still has room to change shape here." : "Keep the page open enough for another pass.")
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.primaryText)
        }
    }

    private var shapeSection: some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            Button {
                withAnimation(.sparkEase) {
                    isShapeExpanded.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shape this")
                            .font(TypographyTokens.sectionTitle)
                            .foregroundStyle(ColorTokens.primaryText)
                        Text("Use a creative move only when you want the page to push back.")
                            .font(TypographyTokens.caption)
                            .foregroundStyle(ColorTokens.secondaryText)
                    }
                    Spacer()
                    if viewModel.state.isRunningSuggestion {
                        ProgressView()
                            .tint(ColorTokens.accent)
                    } else {
                        Image(systemName: isShapeExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(ColorTokens.secondaryText)
                    }
                }
            }
            .buttonStyle(.plain)

            if isShapeExpanded {
                DevelopmentActionsBar(isLoading: viewModel.state.isRunningSuggestion) { action in
                    Task { await viewModel.run(action: action) }
                }
            }
        }
        }
    }

    private func suggestionCard(_ suggestion: DevelopmentSuggestion) -> some View {
        StudioPanel(style: .quiet, accent: ColorTokens.accent, accentEdge: .leading, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                StudioKicker(title: "Working move", tint: ColorTokens.accent)
                Text(suggestion.action.title)
                    .font(TypographyTokens.bodyEmphasis)
                    .foregroundStyle(ColorTokens.primaryText)
                Text(suggestion.content)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                HStack(spacing: SpacingTokens.small) {
                    SPARKButton(title: "Insert into page", variant: .secondary, action: viewModel.acceptSuggestion)
                    SPARKButton(title: "Set aside", variant: .tertiary, action: viewModel.dismissSuggestion)
                }
            }
        }
    }

    private func collapsibleSection<Content: View>(
        title: String,
        subtitle: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        StudioPanel(style: .archival, padding: SpacingTokens.large) {
            VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                Button {
                    withAnimation(.sparkEase) {
                        isExpanded.wrappedValue.toggle()
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(TypographyTokens.sectionTitle)
                                .foregroundStyle(ColorTokens.primaryText)
                            Text(subtitle)
                                .font(TypographyTokens.caption)
                                .foregroundStyle(ColorTokens.secondaryText)
                        }
                        Spacer()
                        Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                            .foregroundStyle(ColorTokens.secondaryText)
                    }
                }
                .buttonStyle(.plain)

                if isExpanded.wrappedValue {
                    content()
                }
            }
        }
    }
}

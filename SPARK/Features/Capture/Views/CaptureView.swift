import SwiftUI

struct CaptureView: View {
    @Environment(RootCoordinator.self) private var coordinator

    @State private var viewModel: CaptureViewModel
    @State private var voiceViewModel: VoiceCaptureViewModel
    @State private var sketchViewModel: SketchCaptureViewModel

    init(
        container: AppContainer,
        initialMode: CaptureMode? = nil,
        stimulusID: UUID? = nil,
        relation: StimulusLinkRelation? = nil,
        draftID: UUID? = nil
    ) {
        let captureViewModel = CaptureViewModel(
            container: container,
            initialMode: initialMode ?? .write,
            stimulusID: stimulusID,
            relation: relation,
            draftID: draftID
        )
        _viewModel = State(initialValue: captureViewModel)
        _voiceViewModel = State(initialValue: VoiceCaptureViewModel(container: container, captureViewModel: captureViewModel))
        _sketchViewModel = State(initialValue: SketchCaptureViewModel(container: container, captureViewModel: captureViewModel))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: SpacingTokens.section) {
                header

                if let sourceStimulus = viewModel.sourceStimulus {
                    SourceStimulusBlock(record: sourceStimulus, isCompressed: !viewModel.text.isBlank || !viewModel.attachments.isEmpty) {
                        coordinator.push(.stimulusDetail(sourceStimulus.id))
                    }
                }

                StudioPanel(style: .focal, accent: ColorTokens.accent, accentEdge: .top, padding: SpacingTokens.large) {
                    VStack(alignment: .leading, spacing: SpacingTokens.medium) {
                        StudioKicker(title: viewModel.sourceStimulus == nil ? "Composer" : composerTitle)
                        Text(viewModel.sourceStimulus == nil ? "A fragment is enough." : sourceLeadIn)
                            .font(TypographyTokens.note)
                            .foregroundStyle(ColorTokens.secondaryText)

                        WriteCaptureView(viewModel: viewModel)

                        VStack(alignment: .leading, spacing: SpacingTokens.small) {
                            StudioKicker(title: "Material within reach")
                            CaptureModeSwitcher(selectedMode: $viewModel.selectedMode)
                                .onChange(of: viewModel.selectedMode) { _, newMode in
                                    viewModel.setMode(newMode)
                                }
                        }
                    }
                }

                if viewModel.selectedMode == .voice || viewModel.hasVoiceAttachment {
                    VoiceCaptureView(viewModel: voiceViewModel)
                }

                if viewModel.selectedMode == .sketch || viewModel.hasSketchAttachment {
                    SketchCaptureView(viewModel: sketchViewModel)
                }

                if !viewModel.attachments.isEmpty {
                    StudioPanel(style: .archival, padding: SpacingTokens.medium) {
                        VStack(alignment: .leading, spacing: SpacingTokens.small) {
                            StudioKicker(title: "Attached material")

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: SpacingTokens.small) {
                                    ForEach(viewModel.attachments, id: \.id) { attachment in
                                        switch attachment {
                                        case .voice(let voice):
                                            attachmentPill(
                                                title: "Voice note",
                                                detail: voice.transcription?.isBlank == false ? "Recorded and transcribed" : "Recorded and ready"
                                            )
                                        case .sketch(let sketch):
                                            attachmentPill(
                                                title: "Sketch",
                                                detail: sketch.note?.isBlank == false ? sketch.note! : "Sketch stored with this thought"
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if !viewModel.tags.isEmpty {
                    StudioPanel(style: .archival, padding: SpacingTokens.medium) {
                        VStack(alignment: .leading, spacing: SpacingTokens.small) {
                            StudioKicker(title: "Themes")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: SpacingTokens.small) {
                                    ForEach(viewModel.tags) { tag in
                                        TagView(tag: tag)
                                    }
                                }
                            }
                        }
                    }
                }

                if viewModel.hasMeaningfulContent {
                    Button("Discard this pass", action: discardComposer)
                        .font(TypographyTokens.footnote)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                }
            }
            .modifier(ScreenPaddingModifier(style: .airy))
            .padding(.vertical, SpacingTokens.pageTop)
        }
        .sparkScreenBackground()
        .modifier(QuietNavigationBarModifier())
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            composerCommitBar
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    private var sourceLeadIn: String {
        switch viewModel.sourceRelation {
        case .builtFrom:
            return "Hold the source softly, then make the thought yours."
        case .respondingTo:
            return "Begin with what it stirred up, not with an explanation."
        case .savedFrom:
            return "Return gently and pick up the thread."
        case nil:
            return "A fragment is enough."
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: SpacingTokens.medium) {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.sourceStimulus == nil ? "Composer" : composerTitle)
                    .font(TypographyTokens.display)
                    .foregroundStyle(ColorTokens.primaryText)
                Text("Write first. Voice and sketch stay close if the thought asks for them.")
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            Spacer()

            Button(action: { coordinator.dismissCapture() }) {
                Image(systemName: "xmark")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ColorTokens.primaryText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                            .fill(ColorTokens.page)
                            .overlay(
                                RoundedRectangle(cornerRadius: RadiusTokens.button, style: .continuous)
                                    .stroke(ColorTokens.hairline, lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var composerCommitBar: some View {
        StudioPanel(style: .floating, padding: nil) {
            VStack(spacing: SpacingTokens.small) {
                HStack(spacing: SpacingTokens.small) {
                    AutosaveIndicator(state: viewModel.autosaveState)
                    Spacer()
                    Button("Keep for later", action: continueLater)
                        .font(TypographyTokens.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                        .buttonStyle(.plain)
                }

                SPARKButton(title: "Open as idea", variant: .primary, action: openAsIdea)
                    .opacity(viewModel.hasMeaningfulContent ? 1 : 0.45)
                    .disabled(!viewModel.hasMeaningfulContent)
            }
            .padding(.horizontal, SpacingTokens.pageInset)
            .padding(.top, SpacingTokens.medium)
            .padding(.bottom, SpacingTokens.medium)
        }
        .padding(.horizontal, SpacingTokens.pageInset)
        .padding(.top, SpacingTokens.small)
    }

    private var composerTitle: String {
        switch viewModel.sourceRelation {
        case .builtFrom:
            return "Build from stimulus"
        case .respondingTo:
            return "Respond to stimulus"
        case .savedFrom:
            return "Return from saved stimulus"
        case nil:
            return "Composer"
        }
    }

    private func continueLater() {
        try? viewModel.continueLater()
        coordinator.dismissCapture()
    }

    private func openAsIdea() {
        guard let ideaID = try? viewModel.saveAsIdea() else { return }
        coordinator.dismissCapture()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            coordinator.openIdeaDetail(ideaID)
        }
    }

    private func discardComposer() {
        try? viewModel.discard()
        coordinator.dismissCapture()
    }

    @ViewBuilder
    private func attachmentPill(title: String, detail: String) -> some View {
        HStack(spacing: SpacingTokens.small) {
            Text(title)
                .font(TypographyTokens.bodyEmphasis)
                .foregroundStyle(ColorTokens.primaryText)
            Text(detail)
                .font(TypographyTokens.caption)
                .foregroundStyle(ColorTokens.secondaryText)
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTokens.medium)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(ColorTokens.pageWarm.opacity(0.92))
                .overlay(Capsule(style: .continuous).stroke(ColorTokens.hairline, lineWidth: 1))
        )
    }
}

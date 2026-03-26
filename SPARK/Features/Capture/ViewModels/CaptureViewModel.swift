import Foundation
import Observation

enum AutosaveState: Equatable {
    case idle
    case saving
    case saved(String)
}

@Observable
@MainActor
final class CaptureViewModel {
    private let captureService: any CaptureService
    private let stimulusRepository: any StimulusRepository
    private let draftRepository: any DraftRepository

    private let initialDraftID: UUID?
    private let initialStimulusID: UUID?
    private let initialRelation: StimulusLinkRelation?
    private var autosaveTask: Task<Void, Never>?

    var selectedMode: CaptureMode
    var sourceStimulus: StimulusRecord?
    var draft: Draft?
    var text: String = ""
    var tags: [Tag] = []
    var attachments: [Attachment] = []
    var autosaveState: AutosaveState = .idle
    var hasLoaded = false

    init(
        container: AppContainer,
        initialMode: CaptureMode,
        stimulusID: UUID? = nil,
        relation: StimulusLinkRelation? = nil,
        draftID: UUID? = nil
    ) {
        captureService = container.services.captureService
        stimulusRepository = container.services.stimulusRepository
        draftRepository = container.services.draftRepository
        initialDraftID = draftID
        initialStimulusID = stimulusID
        initialRelation = relation
        selectedMode = initialMode
    }

    var hasMeaningfulContent: Bool {
        !text.isBlank || !attachments.isEmpty
    }

    var hasVoiceAttachment: Bool {
        attachments.contains {
            if case .voice = $0 { return true }
            return false
        }
    }

    var hasSketchAttachment: Bool {
        attachments.contains {
            if case .sketch = $0 { return true }
            return false
        }
    }

    var placeholderText: String {
        guard let sourceStimulus else {
            return "Start anywhere. A fragment is enough."
        }

        if initialRelation == .builtFrom {
            switch sourceStimulus.payload {
            case .artifact(let payload):
                return "Borrow the move: \(payload.borrowableMove)"
            case .caseStudy(let payload):
                return "Apply the lesson: \(payload.lesson)"
            case .contrast(let payload):
                return "Choose a side or name the tension: \(payload.tension)"
            case .pattern(let payload):
                return "Use the mechanism somewhere real: \(payload.mechanism)"
            case .collision(let payload):
                return "Push the synthesis angle: \(payload.buildAngle)"
            }
        }

        return sourceStimulus.responseCue ?? "Respond to what this brought up."
    }

    var sourceRelation: StimulusLinkRelation? {
        draft?.sourceStimulusLink?.relation ?? initialRelation
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        if let initialDraftID, let existingDraft = try? captureService.loadDraft(id: initialDraftID) {
            draft = existingDraft
            selectedMode = existingDraft.mode
            text = existingDraft.text
            tags = existingDraft.tags
            attachments = existingDraft.attachments
            if let stimulusID = existingDraft.primaryStimulusID {
                sourceStimulus = try? stimulusRepository.record(id: stimulusID)
            }
        } else {
            let relation = initialRelation ?? .respondingTo
            let freshDraft = captureService.createDraft(mode: selectedMode, stimulusID: initialStimulusID, relation: relation)
            draft = freshDraft
            if let initialStimulusID {
                sourceStimulus = try? stimulusRepository.record(id: initialStimulusID)
            }
        }
    }

    func setMode(_ mode: CaptureMode) {
        selectedMode = mode
        if var draft {
            draft.mode = mode
            self.draft = draft
            scheduleAutosave()
        }
    }

    func updateText(_ text: String) {
        self.text = text
        scheduleAutosave()
    }

    func addTag(named name: String) {
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty, !tags.contains(where: { $0.name.caseInsensitiveCompare(normalized) == .orderedSame }) else { return }
        tags.append(Tag(name: normalized))
        scheduleAutosave()
    }

    func removeTag(_ tag: Tag) {
        tags.removeAll { $0.id == tag.id }
        scheduleAutosave()
    }

    func attachVoice(_ attachment: VoiceAttachment) {
        attachments.removeAll {
            if case .voice = $0 { return true }
            return false
        }
        attachments.append(.voice(attachment))
        selectedMode = .voice
        scheduleAutosave()
    }

    func attachSketch(_ attachment: SketchAttachment) {
        attachments.removeAll {
            if case .sketch = $0 { return true }
            return false
        }
        attachments.append(.sketch(attachment))
        selectedMode = .sketch
        scheduleAutosave()
    }

    func continueLater() throws {
        try persistCurrentDraft(message: "Saved just now")
    }

    func saveAsIdea() throws -> UUID {
        try persistCurrentDraft(message: "Saved just now")
        guard let draft else {
            throw NSError(domain: "Capture", code: 1, userInfo: [NSLocalizedDescriptionKey: "Draft unavailable"])
        }
        let idea = try captureService.promoteDraftToIdeaSheet(draft)
        autosaveState = .saved("Saved to Library")
        return idea.id
    }

    func discard() throws {
        autosaveTask?.cancel()
        if let draftID = draft?.id {
            try captureService.discardDraft(id: draftID)
        }
        draft = nil
        text = ""
        tags = []
        attachments = []
        autosaveState = .idle
    }

    private func scheduleAutosave() {
        autosaveTask?.cancel()
        autosaveTask = Task { [weak self] in
            guard let self else { return }
            self.autosaveState = .saving
            try? await Task.sleep(for: .milliseconds(600))
            guard !Task.isCancelled else { return }
            try? self.persistCurrentDraft(message: "Autosaved")
        }
    }

    private func persistCurrentDraft(message: String) throws {
        let relation = initialRelation ?? .respondingTo
        var draft = draft ?? captureService.createDraft(mode: selectedMode, stimulusID: sourceStimulus?.id ?? initialStimulusID, relation: relation)
        draft.mode = selectedMode
        draft.text = text
        draft.tags = tags
        draft.attachments = attachments
        draft.primaryStimulusID = sourceStimulus?.id ?? initialStimulusID
        if draft.stimulusLinks.isEmpty, let stimulus = sourceStimulus?.stimulus {
            draft.stimulusLinks = [stimulus.makeLink(relation: relation)]
        }
        draft.updatedAt = .now
        self.draft = draft
        try captureService.saveDraft(draft)
        autosaveState = .saved(message)
    }
}

import Foundation
import Observation

@Observable
@MainActor
final class IdeaDetailViewModel {
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository
    private let developmentActionService: any DevelopmentActionService
    private let onboardingService: any OnboardingService

    private let ideaID: UUID
    private var autosaveTask: Task<Void, Never>?

    var state = IdeaDetailState()
    var idea: IdeaSheet?
    var sourceStimulus: StimulusRecord?
    var relatedIdeas: [IdeaSheet] = []

    init(container: AppContainer, ideaID: UUID) {
        self.ideaRepository = container.services.ideaRepository
        self.stimulusRepository = container.services.stimulusRepository
        self.developmentActionService = container.services.developmentActionService
        self.onboardingService = container.services.onboardingService
        self.ideaID = ideaID
    }

    func load() {
        state.isLoading = true
        idea = try? ideaRepository.fetch(id: ideaID)
        if let primaryStimulusID = idea?.primaryStimulusID {
            sourceStimulus = try? stimulusRepository.record(id: primaryStimulusID)
        }
        if let idea {
            relatedIdeas = (try? ideaRepository.relatedIdeas(for: idea, limit: 3)) ?? []
            try? ideaRepository.markOpened(idea.id)
        }
        state.isLoading = false
    }

    func updateTitle(_ title: String) {
        guard var idea else { return }
        idea.title = title.isBlank ? nil : title
        idea.inferredTitle = title.isBlank
        mutateAndSave(idea)
    }

    func updateBody(_ body: String) {
        guard var idea else { return }
        idea.body = body
        if idea.title == nil && !body.isBlank {
            idea.inferredTitle = true
        }
        mutateAndSave(idea)
    }

    func toggleFavorite() {
        guard var idea else { return }
        idea.isFavorite.toggle()
        mutateAndSave(idea)
    }

    func addTag(named name: String) {
        guard var idea else { return }
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty, !idea.tags.contains(where: { $0.name.caseInsensitiveCompare(normalized) == .orderedSame }) else { return }
        idea.tags.append(Tag(name: normalized))
        mutateAndSave(idea)
    }

    func removeTag(_ tag: Tag) {
        guard var idea else { return }
        idea.tags.removeAll { $0.id == tag.id }
        mutateAndSave(idea)
    }

    func setContextMarker(_ marker: String?) {
        guard var idea else { return }
        idea.contextMarker = marker
        mutateAndSave(idea)
    }

    func run(action: DevelopmentAction) async {
        guard let idea else { return }
        state.isRunningSuggestion = true
        let profile = try? onboardingService.currentProfile()
        state.suggestion = await developmentActionService.run(
            action: action,
            on: idea,
            sourceStimulus: sourceStimulus?.stimulus,
            profile: profile
        )
        state.isRunningSuggestion = false
    }

    func acceptSuggestion() {
        guard var idea, let suggestion = state.suggestion else { return }
        let separator = idea.body.isBlank ? "" : "\n\n"
        idea.body += "\(separator)Working move — \(suggestion.action.title)\n\(suggestion.content)"
        state.suggestion = nil
        mutateAndSave(idea)
    }

    func dismissSuggestion() {
        state.suggestion = nil
    }

    private func mutateAndSave(_ updatedIdea: IdeaSheet) {
        var updatedIdea = updatedIdea
        updatedIdea.updatedAt = .now
        updatedIdea.revisionCount += 1
        self.idea = updatedIdea
        autosaveTask?.cancel()
        autosaveTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled, let latestIdea = self.idea else { return }
            try? self.ideaRepository.save(latestIdea)
            self.relatedIdeas = (try? self.ideaRepository.relatedIdeas(for: latestIdea, limit: 3)) ?? []
        }
    }
}

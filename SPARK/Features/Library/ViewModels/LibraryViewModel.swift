import Foundation
import Observation

@Observable
@MainActor
final class LibraryViewModel {
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository
    private let draftRepository: any DraftRepository
    private let searchService: any SearchService
    private let resurfacingService: any ResurfacingService

    var isLoading = true
    var selectedTab: LibraryTab = .overview
    var filterState = LibraryFilterState()
    var searchQuery = ""
    var ideas: [IdeaSheet] = []
    var stimuli: [StimulusRecord] = []
    var drafts: [Draft] = []
    var resurfacedItems: [ResurfacedItem] = []

    init(container: AppContainer) {
        ideaRepository = container.services.ideaRepository
        stimulusRepository = container.services.stimulusRepository
        draftRepository = container.services.draftRepository
        searchService = container.services.searchService
        resurfacingService = container.services.resurfacingService
    }

    var filteredIdeas: [IdeaSheet] {
        applyIdeaSort(
            ideas.filter { idea in
                let queryMatches = searchQuery.isBlank ||
                    idea.resolvedTitle.localizedCaseInsensitiveContains(searchQuery) ||
                    idea.body.localizedCaseInsensitiveContains(searchQuery)
                let tagMatches = filterState.selectedTag == nil ||
                    idea.tags.contains(where: { $0.name.caseInsensitiveCompare(filterState.selectedTag!) == .orderedSame })
                let sourceMatches = !filterState.withSourceStimulusOnly || idea.primaryStimulusID != nil
                let voiceMatches = !filterState.hasVoiceOnly || idea.attachments.contains { if case .voice = $0 { return true }; return false }
                let sketchMatches = !filterState.hasSketchOnly || idea.attachments.contains { if case .sketch = $0 { return true }; return false }
                let unfinishedMatches = !filterState.unfinishedOnly || idea.isUnfinished
                return queryMatches && tagMatches && sourceMatches && voiceMatches && sketchMatches && unfinishedMatches
            }
        )
    }

    var filteredStimuli: [StimulusRecord] {
        stimuli.filter { stimulus in
            (
                searchQuery.isBlank ||
                stimulus.stimulus.searchableText.localizedCaseInsensitiveContains(searchQuery)
            ) &&
            (
                filterState.selectedTag == nil ||
                stimulus.taxonomy.domains.map(\.title).contains(filterState.selectedTag!) ||
                stimulus.taxonomy.editorialTags.contains(where: { $0.caseInsensitiveCompare(filterState.selectedTag!) == .orderedSame })
            )
        }
    }

    var filteredDrafts: [Draft] {
        drafts.filter { draft in
            let queryMatches = searchQuery.isBlank || draft.text.localizedCaseInsensitiveContains(searchQuery)
            let voiceMatches = !filterState.hasVoiceOnly || draft.attachments.contains { if case .voice = $0 { return true }; return false }
            let sketchMatches = !filterState.hasSketchOnly || draft.attachments.contains { if case .sketch = $0 { return true }; return false }
            return queryMatches && voiceMatches && sketchMatches
        }
    }

    var continuationIdeas: [IdeaSheet] {
        ideas
            .filter(\.isUnfinished)
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(3)
            .map { $0 }
    }

    var continuationDrafts: [Draft] {
        drafts
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(3)
            .map { $0 }
    }

    var recentIdeas: [IdeaSheet] {
        ideas
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(4)
            .map { $0 }
    }

    var keptStimuliPreview: [StimulusRecord] {
        stimuli
            .sorted { ($0.state.savedAt ?? $0.stimulus.publishedAt) > ($1.state.savedAt ?? $1.stimulus.publishedAt) }
            .prefix(4)
            .map { $0 }
    }

    var hasArchiveContent: Bool {
        !ideas.isEmpty || !stimuli.isEmpty || !drafts.isEmpty
    }

    var hasActiveFilters: Bool {
        filterState != LibraryFilterState()
    }

    var isBrowsingArchive: Bool {
        selectedTab != .overview || !searchQuery.isBlank || hasActiveFilters
    }

    func load() {
        isLoading = true
        ideas = (try? ideaRepository.fetchAll()) ?? []
        stimuli = (try? stimulusRepository.fetchSaved()) ?? []
        drafts = (try? draftRepository.fetchAll())?.filter {
            !$0.wasPromoted && (!$0.text.isBlank || !$0.attachments.isEmpty || $0.primaryStimulusID != nil)
        } ?? []
        resurfacedItems = (try? resurfacingService.libraryCandidates(limit: 3)) ?? []
        isLoading = false
    }

    func enterBrowse(_ tab: LibraryTab) {
        selectedTab = tab
    }

    func returnToOverview() {
        selectedTab = .overview
        searchQuery = ""
        filterState = LibraryFilterState()
        load()
    }

    func refreshSearch() {
        if searchQuery.isBlank {
            load()
        } else if let results = try? searchService.search(query: searchQuery) {
            ideas = results.ideas
            stimuli = results.stimuli
            drafts = results.drafts
        }
    }

    func dismissResurfaced(_ item: ResurfacedItem) {
        resurfacingService.dismiss(item)
        resurfacedItems.removeAll { $0.id == item.id }
    }

    private func applyIdeaSort(_ ideas: [IdeaSheet]) -> [IdeaSheet] {
        switch filterState.sortOption {
        case .recent:
            return ideas.sorted { $0.updatedAt > $1.updatedAt }
        case .oldest:
            return ideas.sorted { $0.updatedAt < $1.updatedAt }
        case .mostRevisited:
            return ideas.sorted { $0.revisionCount > $1.revisionCount }
        case .unfinished:
            return ideas.sorted { ($0.isUnfinished ? 0 : 1, $0.updatedAt) < ($1.isUnfinished ? 0 : 1, $1.updatedAt) }
        }
    }
}

import Foundation
import Observation

struct DiscoverFamilySectionModel: Identifiable, Equatable {
    let family: StimulusFamily
    let stimuli: [StimulusRecord]

    var id: String { family.rawValue }
}

@Observable
@MainActor
final class DiscoverViewModel {
    private let onboardingService: any OnboardingService
    private let stimulusFeedService: any StimulusFeedService
    private let stimulusRepository: any StimulusRepository

    var isLoading = true
    var filterState = DiscoverFilterState()
    var allStimuli: [StimulusRecord] = []

    init(container: AppContainer) {
        onboardingService = container.services.onboardingService
        stimulusFeedService = container.services.stimulusFeedService
        stimulusRepository = container.services.stimulusRepository
    }

    var highlightedStimulus: StimulusRecord? {
        filteredStimuli.first
    }

    var familySections: [DiscoverFamilySectionModel] {
        let leadID = highlightedStimulus?.id
        return StimulusFamily.allCases.compactMap { family in
            let familyStimuli = filteredStimuli.filter { $0.family == family && $0.id != leadID }
            guard !familyStimuli.isEmpty else { return nil }
            return DiscoverFamilySectionModel(family: family, stimuli: Array(familyStimuli.prefix(4)))
        }
    }

    var filteredStimuli: [StimulusRecord] {
        allStimuli.filter { stimulus in
            let familyMatches = filterState.selectedFamily == nil || stimulus.family == filterState.selectedFamily
            let domainMatches = filterState.selectedDomain == nil || stimulus.taxonomy.domains.contains(filterState.selectedDomain!)
            return familyMatches && domainMatches && !stimulus.isDismissed
        }
    }

    var hasActiveFilters: Bool {
        filterState.selectedFamily != nil || filterState.selectedDomain != nil
    }

    var activeFilterLabels: [String] {
        [filterState.selectedFamily?.title, filterState.selectedDomain?.title].compactMap { $0 }
    }

    func load() async {
        isLoading = true
        let profile = try? onboardingService.currentProfile()
        allStimuli = await stimulusFeedService.loadDiscoverStimuli(for: profile)
        isLoading = false
    }

    func clearFilters() {
        filterState = DiscoverFilterState()
    }

    func toggleFamily(_ family: StimulusFamily?) {
        filterState.selectedFamily = filterState.selectedFamily == family ? nil : family
    }

    func toggleDomain(_ domain: InterestDomain?) {
        filterState.selectedDomain = filterState.selectedDomain == domain ? nil : domain
    }

    func toggleSave(_ stimulus: StimulusRecord) {
        try? stimulusRepository.setSaved(!stimulus.isSaved, for: stimulus.id)
        if let index = allStimuli.firstIndex(where: { $0.id == stimulus.id }) {
            allStimuli[index] = (try? stimulusRepository.record(id: stimulus.id)) ?? allStimuli[index]
        }
        Haptics.selection()
    }
}

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let stimulusFeedService: any StimulusFeedService
    private let onboardingService: any OnboardingService
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository
    private let resurfacingService: any ResurfacingService

    var state = HomeSectionState()
    var supportLine = Constants.supportLines.first ?? ""
    var featuredStimulus: StimulusRecord?
    var todayStimuli: [StimulusRecord] = []
    var continueIdea: IdeaSheet?
    var resurfacedItem: ResurfacedItem?
    var profile: UserProfile?

    init(container: AppContainer) {
        stimulusFeedService = container.services.stimulusFeedService
        onboardingService = container.services.onboardingService
        ideaRepository = container.services.ideaRepository
        stimulusRepository = container.services.stimulusRepository
        resurfacingService = container.services.resurfacingService
    }

    var greeting: String {
        Date().timeGreeting
    }

    func load() async {
        state.isLoading = true
        profile = try? onboardingService.currentProfile()
        let feed = await stimulusFeedService.loadHomeFeed(for: profile)
        featuredStimulus = feed.featuredStimulus
        todayStimuli = feed.exploratoryStimuli
        let ideas = ((try? ideaRepository.fetchAll()) ?? []).sorted { $0.updatedAt > $1.updatedAt }
        continueIdea = ideas.first(where: \.isUnfinished)
        resurfacedItem = try? resurfacingService.homeCandidate()
        supportLine = Constants.supportLines.randomElement() ?? supportLine
        state.isLoading = false
    }

    func toggleSave(_ stimulus: StimulusRecord) {
        try? stimulusRepository.setSaved(!stimulus.isSaved, for: stimulus.id)
        if featuredStimulus?.id == stimulus.id {
            featuredStimulus = try? stimulusRepository.record(id: stimulus.id)
        }
        todayStimuli = todayStimuli.map { record in
            record.id == stimulus.id ? ((try? stimulusRepository.record(id: stimulus.id)) ?? record) : record
        }
        Haptics.selection()
    }

    func dismissResurfacedItem() {
        guard let resurfacedItem else { return }
        resurfacingService.dismiss(resurfacedItem)
        self.resurfacedItem = try? resurfacingService.homeCandidate()
    }
}

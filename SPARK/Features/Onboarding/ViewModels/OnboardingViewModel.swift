import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    private let onboardingService: any OnboardingService

    var state = OnboardingState()

    init(container: AppContainer) {
        self.onboardingService = container.services.onboardingService
    }

    var canContinue: Bool {
        switch state.step {
        case .welcome, .thinkingMode, .complete:
            return true
        case .interests:
            return state.selectedInterests.count >= Constants.minimumInterestSelection
        case .intentions:
            return !state.selectedIntents.isEmpty && state.selectedIntents.count <= Constants.maxCreativeIntentSelection
        }
    }

    var progress: Double {
        Double(state.step.rawValue + 1) / Double(OnboardingStep.allCases.count)
    }

    func toggleInterest(_ interest: InterestDomain) {
        if state.selectedInterests.contains(interest) {
            state.selectedInterests.removeAll { $0 == interest }
        } else {
            state.selectedInterests.append(interest)
        }
        Haptics.selection()
    }

    func toggleIntent(_ intent: CreativeIntent) {
        if state.selectedIntents.contains(intent) {
            state.selectedIntents.removeAll { $0 == intent }
        } else if state.selectedIntents.count < Constants.maxCreativeIntentSelection {
            state.selectedIntents.append(intent)
        }
        Haptics.selection()
    }

    func selectMode(_ mode: CaptureMode) {
        state.preferredMode = mode
        Haptics.selection()
    }

    func selectRhythm(_ rhythm: CreativeRhythm) {
        state.creativeRhythm = rhythm
        Haptics.selection()
    }

    func goBack() {
        guard let previous = OnboardingStep(rawValue: state.step.rawValue - 1) else { return }
        state.step = previous
    }

    func goForward() {
        guard canContinue, let next = OnboardingStep(rawValue: state.step.rawValue + 1) else { return }
        state.step = next
    }

    func finish() throws -> UserProfile {
        let profile = UserProfile(
            interests: state.selectedInterests,
            creativeIntents: state.selectedIntents,
            preferredCaptureMode: state.preferredMode,
            creativeRhythm: state.creativeRhythm,
            onboardingCompleted: true,
            updatedAt: .now
        )
        try onboardingService.save(profile: profile)
        Haptics.success()
        return profile
    }
}

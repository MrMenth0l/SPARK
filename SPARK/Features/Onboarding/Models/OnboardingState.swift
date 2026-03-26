import Foundation

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome
    case interests
    case intentions
    case thinkingMode
    case complete

    var id: Int { rawValue }
}

struct OnboardingState {
    var step: OnboardingStep = .welcome
    var selectedInterests: [InterestDomain] = []
    var selectedIntents: [CreativeIntent] = []
    var preferredMode: CaptureMode = .write
    var creativeRhythm: CreativeRhythm = .both
}

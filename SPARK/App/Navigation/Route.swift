import Foundation

enum Route: Hashable {
    case onboarding
    case ideaDetail(UUID)
    case capture(mode: CaptureMode, stimulusID: UUID?, relation: StimulusLinkRelation?, draftID: UUID?)
    case stimulusDetail(UUID)
}

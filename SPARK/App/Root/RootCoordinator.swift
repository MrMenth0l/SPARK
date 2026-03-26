import Foundation
import Observation

@Observable
@MainActor
final class RootCoordinator: Router {
    struct CaptureLaunchContext: Equatable, Identifiable {
        let id = UUID()
        var mode: CaptureMode
        var stimulusID: UUID?
        var relation: StimulusLinkRelation?
        var draftID: UUID?
    }

    let navigationState = NavigationState()

    var selectedTab: AppTab = .home
    var presentedCaptureContext: CaptureLaunchContext?
    var presentedStimulusID: UUID?

    init(container: AppContainer) {
        _ = container
    }

    func push(_ route: Route) {
        switch route {
        case .capture(let mode, let stimulusID, let relation, let draftID):
            openCapture(mode: mode, stimulusID: stimulusID, relation: relation, draftID: draftID)
        case .stimulusDetail(let stimulusID):
            presentedStimulusID = stimulusID
        default:
            navigationState.path.append(route)
        }
    }

    func pop() {
        _ = navigationState.path.popLast()
    }

    func popToRoot() {
        navigationState.path.removeAll()
    }

    func openCapture(
        mode: CaptureMode,
        stimulusID: UUID? = nil,
        relation: StimulusLinkRelation? = nil,
        draftID: UUID? = nil
    ) {
        presentedCaptureContext = CaptureLaunchContext(
            mode: mode,
            stimulusID: stimulusID,
            relation: relation,
            draftID: draftID
        )
    }

    func openIdeaDetail(_ ideaID: UUID) {
        navigationState.path.append(.ideaDetail(ideaID))
    }

    func dismissStimulusDetail() {
        presentedStimulusID = nil
    }

    func dismissCapture() {
        presentedCaptureContext = nil
    }
}

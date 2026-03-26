import Foundation
import Observation

@Observable
final class NavigationState {
    var path: [Route] = []
}

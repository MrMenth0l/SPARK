import Foundation

@MainActor
protocol Router: AnyObject {
    func push(_ route: Route)
    func pop()
    func popToRoot()
}

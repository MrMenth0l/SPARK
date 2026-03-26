import SwiftData
import SwiftUI

@main
struct SPARKApp: App {
    private let persistenceController: PersistenceController
    @State private var appContainer: AppContainer
    @State private var rootCoordinator: RootCoordinator

    init() {
        let persistenceController = PersistenceController()
        let appContainer = AppContainer.live(persistenceController: persistenceController)
        self.persistenceController = persistenceController
        _appContainer = State(initialValue: appContainer)
        _rootCoordinator = State(initialValue: RootCoordinator(container: appContainer))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appContainer)
                .environment(rootCoordinator)
                .preferredColorScheme(.light)
        }
        .modelContainer(persistenceController.modelContainer)
    }
}

import SwiftUI

@main
struct BioBridgeLabApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ExplorerHomeView()
            }
            .environment(appState)
            .environment(\.appFontScale, appState.largeTextEnabled ? 1.3 : 1.0)
            .environment(\.dynamicTypeSize, appState.largeTextEnabled ? .xLarge : .large)
            .preferredColorScheme(.dark)
        }
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            if appState.isAuthenticated {
                RootTabView()
            } else {
                LoginView()
            }
        }
        .environmentObject(appState)
        .preferredColorScheme(appState.isDarkMode ? .dark : .light)
    }
}

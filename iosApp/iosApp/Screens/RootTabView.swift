import SwiftUI
import UIKit

struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label(appState.t.tabHome, systemImage: "house.fill") }

            SearchFormView()
                .tabItem { Label(appState.t.tabSearch, systemImage: "magnifyingglass") }

            HistoryView()
                .tabItem { Label(appState.t.tabHistory, systemImage: "clock.arrow.circlepath") }

            SettingsView()
                .tabItem { Label(appState.t.tabSettings, systemImage: "gearshape.fill") }
        }
        .tint(BRColor.rail)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(BRColor.surface)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

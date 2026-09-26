import SwiftUI

enum AuthState {
    case idle, loading, success, error(String)
}

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var phoneNumber = "1797751266"

    @Published var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: Keys.isDarkMode) }
    }
    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: Keys.language) }
    }

    var t: L10n { language == .english ? .english : .bangla }

    private enum Keys {
        static let isDarkMode = "br.isDarkMode"
        static let language = "br.language"
    }

    init() {
        let defaults = UserDefaults.standard
        isDarkMode = defaults.object(forKey: Keys.isDarkMode) as? Bool ?? true
        language = defaults.string(forKey: Keys.language).flatMap(AppLanguage.init(rawValue:)) ?? .english
    }
}

/// Push destinations shared across the tab stack.
enum AppRoute: Hashable {
    case searchResults(from: Station, to: Station, date: String)
    case trainSearch(query: String)
    case trainDetail(TrainSchedule)
}

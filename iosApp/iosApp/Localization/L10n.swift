import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english, bangla
    var id: Self { self }

    var label: String {
        switch self {
        case .english: return "English"
        case .bangla: return "বাংলা"
        }
    }
}

/// Strings for the app's primary flows: navigation, login, home, and settings.
/// Deeper screens (train detail, station picker) remain English-only for now.
struct L10n {
    // Tab bar
    let tabHome: String
    let tabSearch: String
    let tabHistory: String
    let tabSettings: String

    // Login
    let appTagline: String
    let phonePlaceholder: String
    let passwordPlaceholder: String
    let signIn: String
    let signingIn: String
    let forgotPassword: String
    let newUser: String
    let signUpNow: String
    let incorrectPassword: String

    // Home
    let goodEvening: String
    let quickActions: String
    let placesOfInterest: String
    let stMartinsTitle: String
    let stMartinsSubtitle: String

    // Journey planner
    let byRoute: String
    let byTrain: String
    let from: String
    let to: String
    let searchTrains: String
    let trainNameOrNumber: String

    // History
    let tripHistory: String

    // Settings
    let settingsTitle: String
    let profile: String
    let appearance: String
    let light: String
    let dark: String
    let language: String
    let signOut: String

    static let english = L10n(
        tabHome: "Home",
        tabSearch: "Search",
        tabHistory: "History",
        tabSettings: "Settings",
        appTagline: "Track and book Bangladesh Railway journeys",
        phonePlaceholder: "1797751266",
        passwordPlaceholder: "Password",
        signIn: "Sign In",
        signingIn: "Signing in",
        forgotPassword: "Forgot the password?",
        newUser: "New user?",
        signUpNow: "Sign up now",
        incorrectPassword: "Incorrect password. Try again.",
        goodEvening: "Good evening",
        quickActions: "Quick actions",
        placesOfInterest: "Places of Interest",
        stMartinsTitle: "St. Martin's Island",
        stMartinsSubtitle: "A coral island retreat in the Bay of Bengal",
        byRoute: "By Route",
        byTrain: "By Train",
        from: "From",
        to: "To",
        searchTrains: "Search Trains",
        trainNameOrNumber: "Train name or number",
        tripHistory: "Trip history",
        settingsTitle: "Settings",
        profile: "Profile",
        appearance: "Appearance",
        light: "Light",
        dark: "Dark",
        language: "Language",
        signOut: "Sign out"
    )

    static let bangla = L10n(
        tabHome: "হোম",
        tabSearch: "খুঁজুন",
        tabHistory: "ইতিহাস",
        tabSettings: "সেটিংস",
        appTagline: "বাংলাদেশ রেলওয়ের যাত্রা ট্র্যাক ও বুক করুন",
        phonePlaceholder: "১৭৯৭৭৫১২৬৬",
        passwordPlaceholder: "পাসওয়ার্ড",
        signIn: "সাইন ইন",
        signingIn: "সাইন ইন হচ্ছে",
        forgotPassword: "পাসওয়ার্ড ভুলে গেছেন?",
        newUser: "নতুন ব্যবহারকারী?",
        signUpNow: "এখনই সাইন আপ করুন",
        incorrectPassword: "ভুল পাসওয়ার্ড। আবার চেষ্টা করুন।",
        goodEvening: "শুভ সন্ধ্যা",
        quickActions: "দ্রুত কার্যক্রম",
        placesOfInterest: "দর্শনীয় স্থান",
        stMartinsTitle: "সেন্ট মার্টিন দ্বীপ",
        stMartinsSubtitle: "বঙ্গোপসাগরের একটি প্রবাল দ্বীপ",
        byRoute: "রুট দ্বারা",
        byTrain: "ট্রেন দ্বারা",
        from: "থেকে",
        to: "পর্যন্ত",
        searchTrains: "ট্রেন খুঁজুন",
        trainNameOrNumber: "ট্রেনের নাম বা নম্বর",
        tripHistory: "ভ্রমণ ইতিহাস",
        settingsTitle: "সেটিংস",
        profile: "প্রোফাইল",
        appearance: "থিম",
        light: "লাইট",
        dark: "ডার্ক",
        language: "ভাষা",
        signOut: "সাইন আউট"
    )
}

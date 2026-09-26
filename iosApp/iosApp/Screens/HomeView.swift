import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var fromStation = MockData.stations[2] // Khulna
    @State private var toStation = MockData.stations[0]   // Dhaka
    @State private var date = Date()
    @State private var navPath = NavigationPath()

    private let quickActions = [
        QuickAction(title: "Train", systemImage: "train.side.front.car"),
        QuickAction(title: "Search", systemImage: "magnifyingglass"),
        QuickAction(title: "Account", systemImage: "person.fill"),
        QuickAction(title: "Routes", systemImage: "map.fill"),
        QuickAction(title: "Amenity", systemImage: "list.bullet.rectangle.fill"),
        QuickAction(title: "Fare", systemImage: "banknote.fill"),
        QuickAction(title: "Ticket", systemImage: "ticket.fill"),
        QuickAction(title: "Freight", systemImage: "shippingbox.fill"),
        QuickAction(title: "Predict", systemImage: "chart.line.uptrend.xyaxis"),
        QuickAction(title: "About", systemImage: "info.circle.fill"),
    ]

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    JourneyPlannerCard(from: $fromStation, to: $toStation) {
                        navPath.append(AppRoute.searchResults(from: fromStation, to: toStation, date: formattedDate))
                    } onSearchByTrain: { query in
                        navPath.append(AppRoute.trainSearch(query: query))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text(appState.t.quickActions)
                            .font(BRFont.body(13, weight: .semibold))
                            .foregroundStyle(BRColor.textSecondary)
                        QuickActionsRow(actions: quickActions) { _ in
                            navPath.append(AppRoute.searchResults(from: fromStation, to: toStation, date: formattedDate))
                        }
                    }

                    liveStatusSnippet

                    placesOfInterest
                }
                .padding(20)
            }
            .background(BRColor.ink)
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .searchResults(let from, let to, let date):
                    SearchResultsView(from: from, to: to, date: date)
                case .trainSearch(let query):
                    TrainSearchResultsView(query: query)
                case .trainDetail(let train):
                    TrainDetailView(train: train)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(appState.t.goodEvening)
                    .font(BRFont.body(13))
                    .foregroundStyle(BRColor.textSecondary)
                Text("+880 \(appState.phoneNumber)")
                    .font(BRFont.display(22))
                    .foregroundStyle(BRColor.textPrimary)
            }
            Spacer()
            HStack(spacing: 14) {
                Image(systemName: "bell")
                    .font(.system(size: 17))
                    .foregroundStyle(BRColor.textPrimary)
                Circle()
                    .fill(BRColor.surfaceRaised)
                    .frame(width: 34, height: 34)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(BRColor.textSecondary)
                    )
            }
        }
        .padding(.top, 8)
    }

    private var liveStatusSnippet: some View {
        let train = MockData.sundarban
        return Button {
            navPath.append(AppRoute.trainDetail(train))
        } label: {
            BRCard {
                HStack(spacing: 14) {
                    SignalDot(status: train.status, pulsing: true)
                        .padding(.leading, 16)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(train.number) · \(train.name)")
                            .font(BRFont.body(14, weight: .semibold))
                            .foregroundStyle(BRColor.textPrimary)
                        Text("Now at \(train.currentLocation) · delay \(train.delay)")
                            .font(BRFont.body(12))
                            .foregroundStyle(BRColor.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BRColor.textSecondary)
                        .padding(.trailing, 16)
                }
                .padding(.vertical, 14)
            }
        }
        .buttonStyle(.plain)
    }

    private var placesOfInterest: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(appState.t.placesOfInterest)
                .font(BRFont.body(13, weight: .semibold))
                .foregroundStyle(BRColor.textSecondary)

            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(red: 0.09, green: 0.35, blue: 0.55), Color(red: 0.04, green: 0.16, blue: 0.28)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.t.stMartinsTitle)
                        .font(BRFont.display(17))
                        .foregroundStyle(.white)
                    Text(appState.t.stMartinsSubtitle)
                        .font(BRFont.body(12))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(16)
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}

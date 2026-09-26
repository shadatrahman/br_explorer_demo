import SwiftUI

/// Search tab root — same journey-planner job as the home card, reachable
/// directly without scrolling past the dashboard.
struct SearchFormView: View {
    @EnvironmentObject private var appState: AppState
    @State private var fromStation = MockData.stations[2]
    @State private var toStation = MockData.stations[0]
    @State private var date = Date()
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(appState.t.searchTrains)
                        .font(BRFont.display(24))
                        .foregroundStyle(BRColor.textPrimary)
                        .padding(.top, 8)

                    JourneyPlannerCard(from: $fromStation, to: $toStation) {
                        navPath.append(AppRoute.searchResults(from: fromStation, to: toStation, date: formattedDate))
                    } onSearchByTrain: { query in
                        navPath.append(AppRoute.trainSearch(query: query))
                    }
                }
                .padding(20)
            }
            .background(BRColor.ink)
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

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}

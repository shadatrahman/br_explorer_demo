import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(appState.t.tripHistory)
                        .font(BRFont.display(24))
                        .foregroundStyle(BRColor.textPrimary)
                        .padding(.top, 8)

                    VStack(spacing: 12) {
                        ForEach(MockData.history) { entry in
                            NavigationLink(value: AppRoute.trainDetail(entry.train)) {
                                HistoryRow(entry: entry)
                            }
                            .buttonStyle(.plain)
                        }
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
}

private struct HistoryRow: View {
    let entry: HistoryEntry

    var body: some View {
        BRCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text(entry.train.number)
                        .font(BRFont.data(13, weight: .semibold))
                        .foregroundStyle(BRColor.rail)
                    Text(entry.train.name)
                        .font(BRFont.body(16, weight: .semibold))
                        .foregroundStyle(BRColor.textPrimary)
                    Spacer()
                    Text(entry.outcome.label)
                        .font(BRFont.body(12, weight: .medium))
                        .foregroundStyle(entry.outcome.color)
                }

                Text("\(entry.train.origin) → \(entry.train.destination)")
                    .font(BRFont.body(13))
                    .foregroundStyle(BRColor.textSecondary)

                PerforatedDivider()

                HStack {
                    Text(entry.tripDate)
                        .font(BRFont.data(13))
                        .foregroundStyle(BRColor.textSecondary)
                    Spacer()
                    Text(entry.fareClass)
                        .font(BRFont.body(12, weight: .medium))
                        .foregroundStyle(BRColor.textSecondary)
                }
            }
            .padding(16)
        }
    }
}

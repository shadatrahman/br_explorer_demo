import SwiftUI

struct TrainSearchResultsView: View {
    let query: String

    @Environment(\.dismiss) private var dismiss

    private var matches: [TrainSchedule] {
        MockData.searchResults.filter {
            $0.name.localizedCaseInsensitiveContains(query) || $0.number.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(matches.isEmpty ? "No matches" : "\(matches.count) matching trains")
                    .font(BRFont.body(13, weight: .semibold))
                    .foregroundStyle(BRColor.textSecondary)

                if matches.isEmpty {
                    Text("No trains named \u{201C}\(query)\u{201D}. Try a different name or number.")
                        .font(BRFont.body(14))
                        .foregroundStyle(BRColor.textSecondary)
                        .padding(.top, 8)
                } else {
                    ConfirmedTrainList(trains: matches)
                }
            }
            .padding(20)
        }
        .background(BRColor.ink)
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top, spacing: 0) { topBar }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(BRColor.textPrimary)
                    .frame(width: 34, height: 34)
                    .background(BRColor.surfaceRaised)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Search")
                    .font(BRFont.body(15, weight: .semibold))
                    .foregroundStyle(BRColor.textPrimary)
                Text("\u{201C}\(query)\u{201D}")
                    .font(BRFont.data(12))
                    .foregroundStyle(BRColor.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(BRColor.ink)
    }
}

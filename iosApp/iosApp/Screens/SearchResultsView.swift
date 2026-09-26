import SwiftUI

struct SearchResultsView: View {
    let from: Station
    let to: Station
    let date: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(MockData.searchResults.count) trains")
                    .font(BRFont.body(13, weight: .semibold))
                    .foregroundStyle(BRColor.textSecondary)

                ConfirmedTrainList(trains: MockData.searchResults)
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
                Text("\(from.name) → \(to.name)")
                    .font(BRFont.body(15, weight: .semibold))
                    .foregroundStyle(BRColor.textPrimary)
                Text(date)
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

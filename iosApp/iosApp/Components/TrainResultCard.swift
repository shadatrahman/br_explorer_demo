import SwiftUI

struct TrainResultCard: View {
    let train: TrainSchedule

    var body: some View {
        BRCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(train.number)
                        .font(BRFont.data(13, weight: .semibold))
                        .foregroundStyle(BRColor.rail)
                    Text(train.name)
                        .font(BRFont.body(16, weight: .semibold))
                        .foregroundStyle(BRColor.textPrimary)
                    Spacer()
                }

                HStack {
                    timeBlock(label: "Departs", time: train.departure, place: train.origin)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12))
                        .foregroundStyle(BRColor.textSecondary)
                    Spacer()
                    timeBlock(label: "Arrives", time: train.arrival, place: train.destination, alignTrailing: true)
                }

                PerforatedDivider()

                HStack(spacing: 16) {
                    ForEach(train.fares) { fare in
                        HStack(spacing: 6) {
                            Text(fare.abbreviation)
                                .font(BRFont.body(11, weight: .medium))
                                .foregroundStyle(BRColor.textSecondary)
                            Text("৳\(fare.fare)")
                                .font(BRFont.data(13, weight: .semibold))
                                .foregroundStyle(BRColor.textPrimary)
                        }
                    }
                    Spacer()
                }
            }
            .padding(16)
        }
    }

    private func timeBlock(label: String, time: String, place: String, alignTrailing: Bool = false) -> some View {
        VStack(alignment: alignTrailing ? .trailing : .leading, spacing: 2) {
            Text(time)
                .font(BRFont.data(20, weight: .semibold))
                .foregroundStyle(BRColor.textPrimary)
            Text(place)
                .font(BRFont.body(12))
                .foregroundStyle(BRColor.textSecondary)
        }
    }
}

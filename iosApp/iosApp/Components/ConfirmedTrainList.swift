import SwiftUI

/// Renders tappable train result cards that gate live-location access behind
/// a charge confirmation before pushing into TrainDetailView.
struct ConfirmedTrainList: View {
    let trains: [TrainSchedule]

    @State private var pendingTrain: TrainSchedule?
    @State private var confirmedTrain: TrainSchedule?

    var body: some View {
        ForEach(trains) { train in
            Button {
                pendingTrain = train
            } label: {
                TrainResultCard(train: train)
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(item: $confirmedTrain) { train in
            TrainDetailView(train: train)
        }
        .alert(
            "Live location",
            isPresented: Binding(
                get: { pendingTrain != nil },
                set: { isPresented in if !isPresented { pendingTrain = nil } }
            ),
            presenting: pendingTrain
        ) { train in
            Button("Cancel", role: .cancel) {}
            Button("Continue") {
                confirmedTrain = train
                pendingTrain = nil
            }
        } message: { train in
            Text("Viewing \(train.name)'s live position is a paid feature. You'll be charged to continue.")
        }
    }
}

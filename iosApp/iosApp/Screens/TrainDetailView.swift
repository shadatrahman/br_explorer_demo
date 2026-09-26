import SwiftUI
import MapKit

struct TrainDetailView: View {
    let train: TrainSchedule
    @Environment(\.dismiss) private var dismiss
    @State private var showCoachDetail = false
    @State private var cameraPosition: MapCameraPosition

    init(train: TrainSchedule) {
        self.train = train
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: train.liveCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 1.6, longitudeDelta: 1.6)
            )
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Map(position: $cameraPosition) {
                    if !train.routeCoordinates.isEmpty {
                        MapPolyline(coordinates: train.routeCoordinates)
                            .stroke(BRColor.rail.opacity(0.7), lineWidth: 3)
                    }
                    Annotation(train.number, coordinate: train.liveCoordinate) {
                        ZStack {
                            Circle().fill(BRColor.surfaceRaised).frame(width: 30, height: 30)
                            Circle().stroke(train.status.color, lineWidth: 2).frame(width: 30, height: 30)
                            Image(systemName: "train.side.front.car")
                                .font(.system(size: 12))
                                .foregroundStyle(BRColor.textPrimary)
                        }
                    }
                }
                .mapStyle(.standard(elevation: .flat))
                .frame(height: 260)
                .disabled(false)

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(train.number)
                                .font(BRFont.data(15, weight: .semibold))
                                .foregroundStyle(BRColor.rail)
                            Text(train.name)
                                .font(BRFont.display(22))
                                .foregroundStyle(BRColor.textPrimary)
                        }
                        Text("\(train.origin) → \(train.destination)")
                            .font(BRFont.body(14))
                            .foregroundStyle(BRColor.textSecondary)
                    }

                    BRCard {
                        VStack(spacing: 0) {
                            detailRow("Left \(train.origin) at", value: train.departure)
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("ETA at \(train.destination)", value: train.arrival)
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("Now at", value: train.currentLocation)
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("Next stop", value: "\(train.nextStop) · \(train.nextStopETA)")
                            PerforatedDivider().padding(.horizontal, 16)
                            HStack {
                                Text("Delay")
                                    .font(BRFont.body(13))
                                    .foregroundStyle(BRColor.textSecondary)
                                Spacer()
                                HStack(spacing: 6) {
                                    SignalDot(status: train.status, pulsing: train.status != .onTime)
                                    Text(train.delay)
                                        .font(BRFont.data(15, weight: .semibold))
                                        .foregroundStyle(train.status.color)
                                }
                            }
                            .padding(16)
                        }
                    }

                    DisclosureGroup(isExpanded: $showCoachDetail) {
                        VStack(spacing: 0) {
                            detailRow("Total coaches", value: "\(train.totalCoaches)")
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("Coach position", value: train.coachPosition)
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("Current speed", value: "\(train.currentSpeedKmh) km/h")
                            PerforatedDivider().padding(.horizontal, 16)
                            detailRow("Last update", value: train.lastUpdate)
                        }
                        .padding(.top, 4)
                    } label: {
                        Text("Coach & speed detail")
                            .font(BRFont.body(13, weight: .semibold))
                            .foregroundStyle(BRColor.textPrimary)
                    }
                    .tint(BRColor.textSecondary)
                    .padding(16)
                    .background(BRColor.surfaceRaised)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(BRColor.hairline, lineWidth: 1))

                    if !train.fares.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ticket classes")
                                .font(BRFont.body(13, weight: .semibold))
                                .foregroundStyle(BRColor.textSecondary)
                            BRCard {
                                VStack(spacing: 0) {
                                    ForEach(Array(train.fares.enumerated()), id: \.element.id) { index, fare in
                                        HStack {
                                            Text(fare.name)
                                                .font(BRFont.body(14, weight: .medium))
                                                .foregroundStyle(BRColor.textPrimary)
                                            Spacer()
                                            Text("৳\(fare.fare)")
                                                .font(BRFont.data(15, weight: .semibold))
                                                .foregroundStyle(BRColor.textPrimary)
                                        }
                                        .padding(16)
                                        if index < train.fares.count - 1 {
                                            PerforatedDivider().padding(.horizontal, 16)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
        .background(BRColor.ink)
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(BRColor.textPrimary)
                    .frame(width: 34, height: 34)
                    .background(BRColor.surfaceRaised)
                    .clipShape(Circle())
            }
            .padding(.leading, 16)
            .padding(.top, 8)
        }
    }

    private func detailRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(BRFont.body(13))
                .foregroundStyle(BRColor.textSecondary)
            Spacer()
            Text(value)
                .font(BRFont.data(15, weight: .semibold))
                .foregroundStyle(BRColor.textPrimary)
        }
        .padding(16)
    }
}

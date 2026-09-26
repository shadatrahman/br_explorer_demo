import SwiftUI

enum PlannerMode: String, CaseIterable {
    case route = "By Route"
    case train = "By Train"
}

struct JourneyPlannerCard: View {
    @EnvironmentObject private var appState: AppState
    @Binding var from: Station
    @Binding var to: Station
    var onSearch: () -> Void
    var onSearchByTrain: (String) -> Void

    @State private var mode: PlannerMode = .route
    @State private var trainQuery = ""
    @FocusState private var isTrainFieldFocused: Bool

    private enum ActiveField: Identifiable {
        case from, to
        var id: Self { self }
    }
    @State private var activeField: ActiveField?

    var body: some View {
        BRCard {
            VStack(spacing: 0) {
                modeSwitch
                    .padding(16)

                Divider().background(BRColor.hairline)

                if mode == .route {
                    routeFields
                } else {
                    trainField
                }
            }
        }
        .sheet(item: $activeField) { field in
            StationPickerSheet(
                title: field == .from ? "From station" : "To station",
                selected: field == .from ? from : to
            ) { station in
                if field == .from {
                    from = station
                } else {
                    to = station
                }
            }
        }
    }

    private var modeSwitch: some View {
        HStack(spacing: 4) {
            ForEach(PlannerMode.allCases, id: \.self) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { mode = option }
                } label: {
                    Text(label(for: option))
                        .font(BRFont.body(13, weight: .semibold))
                        .foregroundStyle(mode == option ? BRColor.onAccent : BRColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(mode == option ? BRColor.rail : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(BRColor.ink)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func label(for mode: PlannerMode) -> String {
        switch mode {
        case .route: return appState.t.byRoute
        case .train: return appState.t.byTrain
        }
    }

    private var routeFields: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                VStack(spacing: 0) {
                    stationRow(label: appState.t.from, station: from) { activeField = .from }
                    Divider().background(BRColor.hairline)
                    stationRow(label: appState.t.to, station: to) { activeField = .to }
                }

                Button {
                    swap(&from, &to)
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(BRColor.onAccent)
                        .frame(width: 32, height: 32)
                        .background(BRColor.rail)
                        .clipShape(Circle())
                }
                .padding(.trailing, 16)
            }
            Divider().background(BRColor.hairline)

            Button(action: onSearch) {
                Text(appState.t.searchTrains)
            }
            .buttonStyle(BRPrimaryButtonStyle())
            .padding(16)
        }
    }

    private var trainField: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "train.side.front.car")
                    .font(.system(size: 15))
                    .foregroundStyle(BRColor.textSecondary)
                TextField("", text: $trainQuery, prompt: Text(appState.t.trainNameOrNumber).foregroundStyle(BRColor.textSecondary))
                    .font(BRFont.body(16, weight: .medium))
                    .foregroundStyle(BRColor.textPrimary)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .focused($isTrainFieldFocused)
                    .onSubmit(searchByTrain)
            }
            .padding(16)

            if showSuggestions {
                Divider().background(BRColor.hairline)
                suggestionsList
            }

            Divider().background(BRColor.hairline)

            Button {
                searchByTrain()
            } label: {
                Text(appState.t.searchTrains)
            }
            .buttonStyle(BRPrimaryButtonStyle(isEnabled: !trainQuery.trimmingCharacters(in: .whitespaces).isEmpty))
            .disabled(trainQuery.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(16)
        }
    }

    private var trainSuggestions: [TrainSchedule] {
        let trimmed = trainQuery.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        return MockData.searchResults.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed) || $0.number.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private var showSuggestions: Bool {
        isTrainFieldFocused && !trainSuggestions.isEmpty
    }

    private var suggestionsList: some View {
        VStack(spacing: 0) {
            ForEach(trainSuggestions) { train in
                Button {
                    selectSuggestion(train)
                } label: {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(train.name)
                                .font(BRFont.body(14, weight: .medium))
                                .foregroundStyle(BRColor.textPrimary)
                            Text("\(train.origin) → \(train.destination)")
                                .font(BRFont.body(12))
                                .foregroundStyle(BRColor.textSecondary)
                        }
                        Spacer()
                        Text(train.number)
                            .font(BRFont.data(12, weight: .semibold))
                            .foregroundStyle(BRColor.rail)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)

                if train.id != trainSuggestions.last?.id {
                    Divider().background(BRColor.hairline).padding(.leading, 16)
                }
            }
        }
    }

    private func selectSuggestion(_ train: TrainSchedule) {
        trainQuery = train.name
        isTrainFieldFocused = false
        onSearchByTrain(train.name)
    }

    private func searchByTrain() {
        let trimmed = trainQuery.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onSearchByTrain(trimmed)
    }

    private func stationRow(label: String, station: Station, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(BRFont.body(13))
                    .foregroundStyle(BRColor.textSecondary)
                    .frame(width: 44, alignment: .leading)
                Text(station.name)
                    .font(BRFont.body(17, weight: .medium))
                    .foregroundStyle(BRColor.textPrimary)
                Spacer()
                Text(station.code)
                    .font(BRFont.data(13))
                    .foregroundStyle(BRColor.textSecondary)
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

import SwiftUI

struct StationPickerSheet: View {
    let title: String
    let selected: Station
    var onSelect: (Station) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    private var filtered: [Station] {
        guard !query.isEmpty else { return MockData.stations }
        return MockData.stations.filter {
            $0.name.localizedCaseInsensitiveContains(query) || $0.code.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if filtered.isEmpty {
                    Text("No stations match \u{201C}\(query)\u{201D}")
                        .font(BRFont.body(14))
                        .foregroundStyle(BRColor.textSecondary)
                        .listRowBackground(BRColor.ink)
                } else {
                    ForEach(filtered) { station in
                        Button {
                            onSelect(station)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(station.name)
                                        .font(BRFont.body(16, weight: .medium))
                                        .foregroundStyle(BRColor.textPrimary)
                                    Text(station.code)
                                        .font(BRFont.data(12))
                                        .foregroundStyle(BRColor.textSecondary)
                                }
                                Spacer()
                                if station == selected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(BRColor.rail)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(BRColor.surfaceRaised)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(BRColor.ink)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search station or code")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .tint(BRColor.rail)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

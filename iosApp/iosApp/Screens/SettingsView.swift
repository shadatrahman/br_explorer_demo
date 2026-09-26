import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(appState.t.settingsTitle)
                        .font(BRFont.display(24))
                        .foregroundStyle(BRColor.textPrimary)
                        .padding(.top, 8)

                    NavigationLink {
                        ProfileView()
                    } label: {
                        BRCard {
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(BRColor.surface)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 17))
                                            .foregroundStyle(BRColor.textSecondary)
                                    )
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(appState.t.profile)
                                        .font(BRFont.body(15, weight: .semibold))
                                        .foregroundStyle(BRColor.textPrimary)
                                    Text("+880 \(appState.phoneNumber)")
                                        .font(BRFont.data(12))
                                        .foregroundStyle(BRColor.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(BRColor.textSecondary)
                            }
                            .padding(16)
                        }
                    }
                    .buttonStyle(.plain)

                    section(title: appState.t.appearance) {
                        PillSwitch(
                            options: [(false, appState.t.light), (true, appState.t.dark)],
                            selection: $appState.isDarkMode
                        )
                    }

                    section(title: appState.t.language) {
                        PillSwitch(
                            options: AppLanguage.allCases.map { ($0, $0.label) },
                            selection: $appState.language
                        )
                    }
                }
                .padding(20)
            }
            .background(BRColor.ink)
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(BRFont.body(13, weight: .semibold))
                .foregroundStyle(BRColor.textSecondary)
            BRCard { content().padding(16) }
        }
    }
}

/// Two/three-option pill switch — same visual language as the planner mode switch.
private struct PillSwitch<Value: Hashable>: View {
    let options: [(Value, String)]
    @Binding var selection: Value

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.0) { value, label in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selection = value }
                } label: {
                    Text(label)
                        .font(BRFont.body(13, weight: .semibold))
                        .foregroundStyle(selection == value ? BRColor.onAccent : BRColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(selection == value ? BRColor.rail : Color.clear)
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
}

import SwiftUI

/// Pushed from Settings — the account/profile subscreen.
struct ProfileView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(BRColor.surfaceRaised)
                .frame(width: 76, height: 76)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(BRColor.textSecondary)
                )
                .padding(.top, 40)

            Text("+880 \(appState.phoneNumber)")
                .font(BRFont.data(17, weight: .semibold))
                .foregroundStyle(BRColor.textPrimary)

            Spacer()

            Button(appState.t.signOut) {
                withAnimation { appState.isAuthenticated = false }
            }
            .buttonStyle(BRSecondaryButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BRColor.ink)
        .navigationTitle(appState.t.profile)
        .navigationBarTitleDisplayMode(.inline)
    }
}

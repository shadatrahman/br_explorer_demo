import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @State private var localNumber = "1797751266"
    @State private var password = ""
    @State private var showPassword = false
    @State private var authState: AuthState = .idle
    @FocusState private var focusedField: Field?

    private enum Field { case phone, password }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer(minLength: 64)

                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(BRColor.rail)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text("BR")
                                .font(BRFont.body(15, weight: .bold))
                                .foregroundStyle(BRColor.onAccent)
                        )
                    Text("BR Explorer")
                        .font(BRFont.display(26))
                        .foregroundStyle(BRColor.textPrimary)
                    Text(appState.t.appTagline)
                        .font(BRFont.body(14))
                        .foregroundStyle(BRColor.textSecondary)
                }
                .padding(.bottom, 40)

                VStack(spacing: 12) {
                    // Phone
                    HStack(spacing: 10) {
                        Text("+880")
                            .font(BRFont.data(16, weight: .medium))
                            .foregroundStyle(BRColor.textSecondary)
                        Rectangle().fill(BRColor.hairline).frame(width: 1, height: 20)
                        TextField("", text: $localNumber, prompt: Text(appState.t.phonePlaceholder).foregroundStyle(BRColor.textSecondary))
                            .font(BRFont.data(16, weight: .medium))
                            .foregroundStyle(BRColor.textPrimary)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .phone)
                    }
                    .padding(16)
                    .background(BRColor.surfaceRaised)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(focusedField == .phone ? BRColor.rail : BRColor.hairline, lineWidth: 1)
                    )

                    // Password
                    HStack {
                        Group {
                            if showPassword {
                                TextField("", text: $password, prompt: Text(appState.t.passwordPlaceholder).foregroundStyle(BRColor.textSecondary))
                            } else {
                                SecureField("", text: $password, prompt: Text(appState.t.passwordPlaceholder).foregroundStyle(BRColor.textSecondary))
                            }
                        }
                        .font(BRFont.body(16))
                        .foregroundStyle(BRColor.textPrimary)
                        .focused($focusedField, equals: .password)

                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(BRColor.textSecondary)
                        }
                    }
                    .padding(16)
                    .background(BRColor.surfaceRaised)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(focusedField == .password ? BRColor.rail : BRColor.hairline, lineWidth: 1)
                    )

                    if case .error(let message) = authState {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                            Text(message)
                                .font(BRFont.body(13))
                        }
                        .foregroundStyle(BRColor.rail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom, 20)

                Button {
                    signIn()
                } label: {
                    Text(authState.isLoading ? appState.t.signingIn : appState.t.signIn)
                }
                .buttonStyle(BRPrimaryButtonStyle(isLoading: authState.isLoading, isEnabled: canSubmit))
                .disabled(!canSubmit || authState.isLoading)
                .padding(.bottom, 12)

                Button(appState.t.forgotPassword) {}
                    .buttonStyle(BRSecondaryButtonStyle())

                Spacer(minLength: 60)

                Button {
                    // Sign up flow not in scope for prototype.
                } label: {
                    HStack(spacing: 4) {
                        Text(appState.t.newUser)
                            .foregroundStyle(BRColor.textSecondary)
                        Text(appState.t.signUpNow)
                            .foregroundStyle(BRColor.textPrimary)
                            .underline()
                    }
                    .font(BRFont.body(14))
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(BRColor.ink)
        .onTapGesture { focusedField = nil }
    }

    private var canSubmit: Bool {
        localNumber.count >= 10 && !password.isEmpty
    }

    private func signIn() {
        focusedField = nil
        authState = .loading
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            if password.count < 4 {
                authState = .error(appState.t.incorrectPassword)
                return
            }
            authState = .success
            appState.phoneNumber = localNumber
            withAnimation { appState.isAuthenticated = true }
        }
    }
}

private extension AuthState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

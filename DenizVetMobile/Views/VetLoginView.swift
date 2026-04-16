import SwiftUI

struct VetLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorText: String?
    @State private var showForgotPasswordAlert = false

    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountRole") private var accountRole: String = "user"
    @AppStorage("vetRememberMe") private var vetRememberMe: Bool = false
    @AppStorage("vetRememberedUsername") private var vetRememberedUsername: String = ""

    var body: some View {
        ZStack {
            VetLoginBackgroundView()

            VStack(spacing: 0) {
                VetLoginHeaderView()

                VetLoginFieldsView(username: $username, password: $password)

                if let err = errorText {
                    Text(err)
                        .foregroundStyle(.white.opacity(0.92))
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 8)
                }

                VetLoginOptionsRow(
                    rememberMe: $vetRememberMe,
                    forgotPasswordTap: { showForgotPasswordAlert = true }
                )
                .padding(.top, 18)

                VetLoginButtonView(isLoading: isLoading) { await handleVetLogin() }
                    .padding(.top, 24)

                Text("Bu alan yalnızca tanımlı veteriner klinik hesapları içindir.")
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 13, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.top, 18)
            }
            .offset(y: -30)
        }
        .customBackButton()
        .onAppear {
            if vetRememberMe, !vetRememberedUsername.isEmpty {
                username = vetRememberedUsername
            }
        }
        .alert("Şifre Sıfırlama", isPresented: $showForgotPasswordAlert) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text("Veteriner klinik şifre sıfırlama akışını bir sonraki adımda ekleyeceğiz. Şimdilik sistem yöneticinizle iletişime geçebilirsiniz.")
        }
    }

    private func handleVetLogin() async {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !cleanUsername.isEmpty, !password.isEmpty else {
            errorText = "Kullanıcı adı ve şifre gerekli."
            return
        }

        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let resp = try await AuthAPI.shared.vetLogin(username: cleanUsername, password: password)
            authToken = resp.token
            UserDefaults.standard.set(resp.token, forKey: "authToken")
            accountRole = resp.user.role ?? "vet"

            if vetRememberMe {
                vetRememberedUsername = cleanUsername
            } else {
                vetRememberedUsername = ""
            }

            isLoggedIn = true
            dismiss()
        } catch {
            errorText = vetLoginMessage(for: error)
        }
    }

    private func vetLoginMessage(for error: Error) -> String {
        if let httpError = error as? HTTPError {
            let rawMessage = httpError.errorDescription?.lowercased() ?? ""

            if rawMessage.contains("kullanıcı adı veya şifre hatalı")
                || rawMessage.contains("kullanıcı adı ve şifre gerekli")
                || rawMessage.contains("yetkili değil")
            {
                return "Kullanıcı adı veya şifre hatalı."
            }

            if rawMessage.contains("sunucu hatası") {
                return "Giriş sırasında bir sunucu hatası oluştu. Lütfen tekrar deneyin."
            }

            return "Giriş yapılamadı. Lütfen bilgilerinizi kontrol edip tekrar deneyin."
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .networkConnectionLost, .timedOut:
                return "Sunucuya ulaşılamadı. Backend'in çalıştığından emin olup tekrar deneyin."
            default:
                return "Bağlantı sırasında bir sorun oluştu. Lütfen tekrar deneyin."
            }
        }

        return "Giriş yapılamadı. Kullanıcı adı veya şifre hatalı olabilir."
    }
}

@ViewBuilder
func VetLoginBackgroundView() -> some View {
    LinearGradient(
        colors: [
            Color(red: 0.06, green: 0.20, blue: 0.28),
            Color(red: 0.08, green: 0.42, blue: 0.44),
            Color(red: 0.12, green: 0.56, blue: 0.50)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    .ignoresSafeArea()

    Circle()
        .fill(Color.white.opacity(0.08))
        .frame(width: 260, height: 260)
        .blur(radius: 2)
        .offset(x: 130, y: -250)

    Circle()
        .fill(Color.black.opacity(0.12))
        .frame(width: 240, height: 240)
        .blur(radius: 8)
        .offset(x: -120, y: 300)
}

@ViewBuilder
func VetLoginHeaderView() -> some View {
    VStack(spacing: 12) {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.14))
                .frame(width: 96, height: 96)

            Image(systemName: "stethoscope.circle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.white)
        }

        Text("Veteriner Klinik Girişi")
            .font(GilroyFont(isBold: true, size: 30))
            .foregroundStyle(.white)

        Text("Kliniğinize ait kullanıcı adı ve şifrenizle giriş yapın.")
            .foregroundStyle(.white.opacity(0.84))
            .font(GilroyFont(isBold: false, size: 17))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 26)
    }
    .padding(.top, 8)
    .padding(.bottom, 28)
}

@ViewBuilder
func VetLoginOptionsRow(
    rememberMe: Binding<Bool>,
    forgotPasswordTap: @escaping () -> Void
) -> some View {
    HStack {
        Button {
            rememberMe.wrappedValue.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: rememberMe.wrappedValue ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                Text("Beni Hatırla")
                    .foregroundStyle(.white.opacity(0.92))
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .buttonStyle(.plain)

        Spacer()

        Button(action: forgotPasswordTap) {
            Text("Şifremi Unuttum")
                .foregroundStyle(.white.opacity(0.92))
                .font(.system(size: 14, weight: .semibold))
                .underline()
        }
        .buttonStyle(.plain)
    }
    .frame(width: 340)
}

@ViewBuilder
func VetLoginButtonView(isLoading: Bool, onTap: @escaping () async -> Void ) -> some View {
    Button {
        Task { await onTap() }
    } label: {
        Rectangle()
            .frame(width: 340, height: 54)
            .foregroundStyle(.clear)
            .background(Color(red: 0.05, green: 0.34, blue: 0.37))
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 12)
            .overlay {
                HStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .padding(.leading, 16)
                    } else {
                        Text("Giriş Yap")
                            .foregroundStyle(.white)
                            .font(GilroyFont(isBold: true, size: 20))
                            .padding(.leading, 16)
                    }

                    Spacer()

                    Image(systemName: "arrowshape.right.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.white.opacity(0.95))
                        .padding(.trailing, 16)
                }
            }
    }
    .disabled(isLoading)
    .opacity(isLoading ? 0.85 : 1)
}

@ViewBuilder
func VetLoginFieldsView(username: Binding<String>, password: Binding<String>) -> some View {
    VStack(spacing: 14) {
        FieldTitleView("Kullanıcı Adı")

        HStack(spacing: 10) {
            Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.45))
                .frame(width: 28)

            TextField("Kullanıcı Adı", text: username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.username)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(width: 340)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.22), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.14), radius: 14, x: 0, y: 10)

        FieldTitleView("Şifre")

        VetPasswordFieldRow(password: password)
            .frame(width: 340)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.14), radius: 14, x: 0, y: 10)
    }
    .padding(.top, 10)
}

private struct VetPasswordFieldRow: View {
    @Binding var password: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "key.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.45))
                .frame(width: 28)

            Group {
                if isSecure {
                    SecureField("Şifre", text: $password)
                } else {
                    TextField("Şifre", text: $password)
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Spacer()

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.55))
                    .frame(width: 34, height: 34)
                    .contentShape(Rectangle())
            }
            .padding(.trailing, 6)
            .accessibilityLabel(isSecure ? "Şifreyi göster" : "Şifreyi gizle")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
    }
}

#Preview {
    NavigationStack {
        VetLoginView()
    }
}

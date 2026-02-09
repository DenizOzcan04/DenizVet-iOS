//
//  LoginView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 14.10.2025.
//

import SwiftUI

struct LoginView: View {

    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorText : String?
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        ZStack{
            BackgroundView()

            VStack(spacing: 0){
                LogoView()

                FieldsView(phoneNumber: $phoneNumber, password: $password)

                if let err = errorText {
                    Text(err)
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 6)
                }

                ForgotBtnView()

                LoginButtonView(isLoading: isLoading) { await handleLogin() }

                LoginBtnView()
            }
        }
    }
}

@ViewBuilder
func BackgroundView() -> some View {
    Image("LoginBackground")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

    LinearGradient(
        colors: [
            Color.black.opacity(0.55),
            Color.black.opacity(0.20),
            Color.black.opacity(0.55)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    .ignoresSafeArea()

    Color(red: 0.96, green: 0.62, blue: 0.35)
        .opacity(0.12)
        .ignoresSafeArea()
}

@ViewBuilder
func LogoView() -> some View {
    VStack(spacing: 10){
        Image("logo")
            .resizable()
            .frame(width: 92, height: 92)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 10)

        Text("DenizVet'e Hoşgeldiniz")
            .font(GilroyFont(isBold: true, size: 32))
            .foregroundStyle(.white)

        Text("Sevimli Dostunuz İçin En Doğru Yer")
            .foregroundStyle(.white.opacity(0.85))
            .kerning(0.3)
            .font(GilroyFont(isBold: false ,size: 18))
    }
    .padding(.top, 8)
    .padding(.bottom, 28)
    
}
    

@ViewBuilder
func FieldsView(phoneNumber: Binding<String>, password: Binding<String>) -> some View {
    VStack(spacing: 14){

        FieldTitleView("Telefon Numarası")

        HStack(spacing: 10){
            Image(systemName: "iphone.gen2")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.45))
                .frame(width: 28)

            TextField("Telefon Numarası", text: phoneNumber)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(width: 340)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 10)

        FieldTitleView("Şifre")

        PasswordFieldRow(password: password)
            .frame(width: 340)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.92))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 10)
    }
    .padding(.top, 10)
}

@ViewBuilder
func FieldTitleView(_ text: String) -> some View {
    HStack {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white.opacity(0.85))
        Spacer()
    }
    .frame(width: 340)
}

private struct PasswordFieldRow: View {
    @Binding var password: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 10){
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

@ViewBuilder
func ForgotBtnView() -> some View {
    NavigationLink {
      ForgotPasswordView()
    } label: {
        Text("Şifrenizi mi unuttunuz ?")
            .foregroundStyle(.white.opacity(0.9))
            .font(GilroyFont(isBold: true, size: 15))
            .underline()
            .padding(.top, 14)
            .padding(.bottom, 22)
    }
}

@ViewBuilder
func LoginButtonView(isLoading: Bool, onTap: @escaping () async -> Void ) -> some View {
    Button {
        Task { await onTap() }
    } label: {
        Rectangle()
            .frame(width: 340, height: 54)
            .foregroundStyle(.clear)
            .background(Color(red: 0.96, green: 0.58, blue: 0.18))
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 12)
            .overlay{
                HStack{
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

extension LoginView {
    func handleLogin() async {
        let phone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phone.isEmpty, !password.isEmpty else {
            errorText = "Telefon ve şifre gerekli."
            return
        }
        isLoading = true
        defer { isLoading = false }

        do {
            let resp = try await AuthAPI.shared.login(phone: phone, password: password)

            authToken = resp.token
            UserDefaults.standard.set(resp.token, forKey: "authToken")

            isLoggedIn = true

            print("Giriş başarılı, token: \(resp.token)")
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription
            ?? (error as? APIMessage)?.message
            ?? "Bilinmeyen hata"
        }
    }
}

@ViewBuilder
func LoginBtnView() -> some View {
    HStack(spacing: 6){
        Text("Henüz kayıt olmadınız mı ?")
            .font(GilroyFont(size: 15))
            .foregroundStyle(.white.opacity(0.85))

        NavigationLink{
            SignUpView()
        } label: {
            Text("Kayıt Ol")
                .foregroundStyle(.white)
                .font(GilroyFont(isBold: true, size: 15))
                .underline()
        }
    }
    .padding(.top, 18)
    .padding(.bottom, 30)
}

#Preview {
    LoginView()
}

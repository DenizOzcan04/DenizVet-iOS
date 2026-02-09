import SwiftUI

struct SignUpView: View {

    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var isLoading = false
    @State private var errorText: String?
    @State private var successText: String?

    var body: some View {
        ZStack{
            SignUpBackground()

            VStack(spacing: 0){
                SignUpLogoView()

                SignUpFieldsView(phoneNumber: $phoneNumber, password: $password, name: $name, surname: $surname)

                if let err = errorText {
                    Text(err)
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 10)
                }

                if let ok = successText {
                    Text(ok)
                        .foregroundStyle(.white.opacity(0.95))
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 10)
                }

                SignUpBtnView(isLoading: isLoading) { await handleSignup() }
            }
        }
    }
}

@ViewBuilder
func SignUpBackground() -> some View {
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
func SignUpLogoView() -> some View {
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
    .padding(.bottom, 26)
}

@ViewBuilder
func SignUpFieldsView(phoneNumber: Binding<String>, password: Binding<String>, name: Binding<String>, surname: Binding<String>) -> some View {
    VStack(spacing: 14){

        FieldTitleView_SignUp("İsim")

        HStack(spacing: 10){
            Image(systemName: "person.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.45))
                .frame(width: 28)

            TextField("İsim", text: name)
                .keyboardType(.alphabet)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
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

        FieldTitleView_SignUp("Soyisim")

        HStack(spacing: 10){
            Image(systemName: "person.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.45))
                .frame(width: 28)

            TextField("Soyisim", text: surname)
                .keyboardType(.alphabet)
                .textContentType(.familyName)
                .textInputAutocapitalization(.words)
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

        FieldTitleView_SignUp("Telefon Numarası")

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

        FieldTitleView_SignUp("Şifre")

        PasswordFieldRow_SignUp(password: password)
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
func FieldTitleView_SignUp(_ text: String) -> some View {
    HStack {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white.opacity(0.85))
        Spacer()
    }
    .frame(width: 340)
}

private struct PasswordFieldRow_SignUp: View {
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
            .textContentType(.newPassword)
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
        .customBackButton()
    }
}

@ViewBuilder
func SignUpBtnView(isLoading: Bool, onTap: @escaping () async -> Void ) -> some View {
    Button{
        Task{ await onTap() }
    } label:{
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
                        Text("Kayıt Ol")
                            .font(GilroyFont(isBold: true, size: 20))
                            .foregroundStyle(.white)
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
    .padding(.top, 26)
    .padding(.bottom, 30)
}

extension SignUpView {
    private func resetForm(){
        name = ""
        surname = ""
        phoneNumber = ""
        password = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

    }
    func handleSignup() async {
        errorText = nil
        successText = nil

        let phone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let s = surname.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !n.isEmpty, !s.isEmpty, !phone.isEmpty, !password.isEmpty else {
            errorText = "Tüm alanlar zorunludur."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await AuthAPI.shared.signup(
                name: n,
                surname: s,
                phone: phone,
                password: password
            )
            successText = "Kayıt başarılı. Şimdi giriş yapabilirsiniz."
            resetForm()
        } catch {
            errorText =
            (error as? LocalizedError)?.errorDescription
            ?? (error as? APIMessage)?.message
            ?? "Bilinmeyen hata"
        }
    }
}

#Preview {
    SignUpView()
}

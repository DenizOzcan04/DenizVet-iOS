import SwiftUI

struct PasswordAndSecurityView: View {
    @StateObject private var vm = PasswordSecurityViewModel()

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var newPasswordAgain = ""

    @State private var showCurrent = false
    @State private var showNew = false
    @State private var showAgain = false

    @AppStorage("authToken") private var authToken: String = ""

    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(.systemOrange))
                        )
                    
                    Text("Şifrenizi buradan güvenle güncelleyebilirsiniz.")
                        .font(.footnote)

                    VStack(spacing: 18) {
                        PasswordFieldRow(title: "Mevcut Şifre", placeholder: "Mevcut Şifre", text: $currentPassword, isVisible: $showCurrent)
                        PasswordFieldRow(title: "Yeni Şifre", placeholder: "Yeni Şifre", text: $newPassword, isVisible: $showNew)
                        PasswordFieldRow(title: "Yeni Şifre Tekrar", placeholder: "Yeni Şifre Tekrar", text: $newPasswordAgain, isVisible: $showAgain)
                    }
                    .padding(.horizontal, 16)

                    if let e = vm.errorText {
                        Text(e)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }

                    if let s = vm.successText {
                        Text(s)
                            .foregroundStyle(.green)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }

                    Button {
                        Task {
                            await vm.submit(token: authToken, current: currentPassword, new: newPassword, again: newPasswordAgain)
                            if vm.errorText == nil {
                                currentPassword = ""
                                newPassword = ""
                                newPasswordAgain = ""
                                showCurrent = false
                                showNew = false
                                showAgain = false
                            }
                        }
                    } label: {
                        Rectangle()
                            .frame(height: 54)
                            .foregroundStyle(.clear)
                            .background(Color(.systemOrange))
                            .cornerRadius(26)
                            .overlay {
                                if vm.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Şifremi Güncelle")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                    }
                    .disabled(vm.isLoading)
                    .opacity(vm.isLoading ? 0.7 : 1)
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(.systemBackground))
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton("Şifre ve Güvenlik")

    }
}

private struct PasswordFieldRow: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Image(systemName: "person.badge.key.fill")
                    .foregroundStyle(Color(.systemOrange))
                    .padding(.leading, 8)

                Group {
                    if isVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 8)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Spacer()

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundStyle(.black.opacity(0.6))
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
        }
    }
}



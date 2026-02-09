import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.95, blue: 0.89)
                .ignoresSafeArea()

            if vm.isLoading {
                ProgressView("Profil yükleniyor...")
            } else if let error = vm.errorMessage {
                VStack(spacing: 12) {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                    Button("Tekrar dene") {
                        Task { await vm.loadProfile() }
                    }
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 24) {

                            Text("Profil")
                                .font(.system(size: 20, weight: .semibold))

                            VStack(spacing: 8) {
                                ZStack(alignment: .bottomTrailing) {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 96, height: 96)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(Color(.systemOrange))
                                        )

                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 26, height: 26)
                                        .overlay(
                                            Image(systemName: "pencil")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(Color(.systemOrange))
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                        )
                                        .offset(x: 4, y: 4)
                                        .opacity(0.9)
                                }

                                Text(vm.user?.fullName ?? "Kullanıcı")
                                    .font(.system(size: 22, weight: .semibold))
                            }

                            VStack(spacing: 16) {
                                if let user = vm.user {
                                    NavigationLink {
                                        AccountDetailsView(user: user)
                                    } label: {
                                        ProfileRow(systemIcon: "person.fill", title: "Hesap Bilgileri")
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    ProfileRow(systemIcon: "person.fill", title: "Hesap Bilgileri")
                                        .redacted(reason: .placeholder)
                                        .disabled(true)
                                }

                                NavigationLink {
                                    PasswordAndSecurityView()
                                } label: {
                                    ProfileRow(systemIcon: "lock.square", title: "Şifre ve Güvenlik")
                                }
                                .buttonStyle(.plain)

                                NavigationLink {
                                    MyAppointmentsView()
                                } label: {
                                    ProfileRow(systemIcon: "calendar", title: "Randevularım")
                                }
                                .buttonStyle(.plain)

                                NavigationLink {
                                    FAQView()
                                } label: {
                                    ProfileRow(systemIcon: "questionmark.circle.fill",
                                               title: "Sıkça Sorulan Sorular (SSS)")
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                vm.logout()
                            } label: {
                                Text("Çıkış Yap")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(.systemRed))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal, 16)

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 22)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await vm.loadProfile() }
    }
}

#Preview {
    ProfileView()
}

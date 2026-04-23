import SwiftUI

struct VetSettingsView: View {
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountRole") private var accountRole: String = "user"
    @AppStorage("persistSession") private var persistSession: Bool = false
    @AppStorage("vetRememberMe") private var vetRememberMe: Bool = false
    @AppStorage("vetRememberedUsername") private var vetRememberedUsername: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [VetTheme.backgroundTop, VetTheme.secondary, VetTheme.backgroundBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Klinik Ayarları")
                            .font(GilroyFont(isBold: true, size: 28))
                            .foregroundStyle(.white)

                        Text("Veteriner paneli için geçici ayarlar alanı. Klinik profili, müsaitlik ve bildirim seçenekleri bu alanda toplanacak.")
                            .font(GilroyFont(size: 16))
                            .foregroundStyle(VetTheme.mutedText)
                    }

                    VetSettingsCard(
                        title: "Hesap Özeti",
                        icon: "building.2.crop.circle",
                        items: [
                            "Rol: Veteriner Klinik",
                            "Oturum koruma: \(persistSession ? "Açık" : "Kapalı")",
                            "Beni Hatırla: \(vetRememberMe ? "Açık" : "Kapalı")"
                        ]
                    )

                    VetSettingsCard(
                        title: "Yakında Eklenecekler",
                        icon: "sparkles",
                        items: [
                            "Randevu onaylama ve durum güncelleme",
                            "Klinik çalışma saatleri düzenleme",
                            "Hasta geçmişi ve hızlı notlar",
                            "Şifre yenileme ve güvenlik ayarları"
                        ]
                    )

                    Button {
                        authToken = ""
                        isLoggedIn = false
                        accountRole = "user"
                        persistSession = false
                        if !vetRememberMe {
                            vetRememberedUsername = ""
                        }
                        UserDefaults.standard.removeObject(forKey: "authToken")
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Klinik Hesabından Çıkış Yap")
                                .font(GilroyFont(isBold: true, size: 17))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(VetTheme.primary)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .padding(.bottom, 28)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct VetSettingsCard: View {
    let title: String
    let icon: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(VetTheme.primary)

                Text(title)
                    .font(GilroyFont(isBold: true, size: 20))
                    .foregroundStyle(Color.black.opacity(0.82))
            }

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7))
                        .foregroundStyle(VetTheme.accent)
                        .padding(.top, 6)

                    Text(item)
                        .font(GilroyFont(size: 15))
                        .foregroundStyle(Color.black.opacity(0.68))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(VetTheme.cardBackground)
        )
    }
}

#Preview {
    NavigationStack {
        VetSettingsView()
    }
}

import SwiftUI

struct VetClinicPlaceholderView: View {
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountRole") private var accountRole: String = "user"
    @AppStorage("persistSession") private var persistSession: Bool = false
    @AppStorage("vetRememberMe") private var vetRememberMe: Bool = false
    @AppStorage("vetRememberedUsername") private var vetRememberedUsername: String = ""

    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.97, blue: 0.96)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    VetDashboardHero()

                    HStack(spacing: 14) {
                        VetStatCard(title: "Bugünkü Randevu", value: "12", icon: "calendar.badge.clock", tint: Color(red: 0.05, green: 0.34, blue: 0.37))
                        VetStatCard(title: "Bekleyen Onay", value: "4", icon: "hourglass.circle.fill", tint: Color(red: 0.84, green: 0.50, blue: 0.18))
                    }

                    HStack(spacing: 14) {
                        VetStatCard(title: "Aktif Hasta", value: "27", icon: "pawprint.circle.fill", tint: Color(red: 0.15, green: 0.53, blue: 0.49))
                        VetStatCard(title: "Mesajlar", value: "3", icon: "bubble.left.and.bubble.right.fill", tint: Color(red: 0.28, green: 0.43, blue: 0.74))
                    }

                    VetSectionCard(
                        title: "Yaklaşan İşler",
                        items: [
                            "09:30 - Maya için genel muayene",
                            "11:00 - Leo için aşı kontrolü",
                            "13:15 - Boncuk için tırnak bakımı"
                        ]
                    )

                    VetSectionCard(
                        title: "Sonraki Adımda Buraya Eklenecekler",
                        items: [
                            "Klinik randevu listesi",
                            "Randevu durumu onaylama ve tamamlama",
                            "Hasta notları ve hızlı erişim araçları"
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
                        UserDefaults.standard.removeObject(forKey: "currentUser")
                    } label: {
                        Text("Klinik Hesabından Çıkış Yap")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(red: 0.05, green: 0.34, blue: 0.37))
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 24)
            }
        }
    }
}

@ViewBuilder
func VetDashboardHero() -> some View {
    RoundedRectangle(cornerRadius: 30)
        .fill(
            LinearGradient(
                colors: [
                    Color(red: 0.07, green: 0.34, blue: 0.35),
                    Color(red: 0.10, green: 0.53, blue: 0.49)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(height: 236)
        .overlay {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Pati Veteriner Klinik")
                        .font(GilroyFont(isBold: true, size: 28))
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "cross.case.circle.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(.white.opacity(0.92))
                }

                Text("Klinik paneline hoş geldiniz")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.82))

                Text("Bu ekranı test edebilmeniz için geçici ama gerçek bir ana sayfa düzeni hazırladım. Buradan sonraki aşamada randevu ve hasta akışlarını ekleyebiliriz.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.90))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    VetHeroPill(text: "Canlı Test")
                    VetHeroPill(text: "Klinik Akışı")
                }
            }
            .padding(22)
        }
}

@ViewBuilder
func VetHeroPill(text: String) -> some View {
    Text(text)
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.14))
        )
}

@ViewBuilder
func VetStatCard(title: String, value: String, icon: String, tint: Color) -> some View {
    VStack(alignment: .leading, spacing: 14) {
        Image(systemName: icon)
            .font(.system(size: 26))
            .foregroundStyle(tint)

        Text(value)
            .font(GilroyFont(isBold: true, size: 28))
            .foregroundStyle(.black)

        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, minHeight: 138, alignment: .topLeading)
    .padding(18)
    .background(
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
    )
}

@ViewBuilder
func VetSectionCard(title: String, items: [String]) -> some View {
    VStack(alignment: .leading, spacing: 14) {
        Text(title)
            .font(.system(size: 18, weight: .semibold))

        ForEach(items, id: \.self) { item in
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(Color(red: 0.08, green: 0.42, blue: 0.44))
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)

                Text(item)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.black.opacity(0.78))

                Spacer(minLength: 0)
            }
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .background(
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
    )
}

#Preview {
    VetClinicPlaceholderView()
}

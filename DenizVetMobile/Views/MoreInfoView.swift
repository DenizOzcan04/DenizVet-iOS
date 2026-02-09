//
//  MoreInfoView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 21.12.2025.
//

import SwiftUI

struct MoreInfoView: View {
    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("DenizVet ile neler yapabilirsiniz?")
                            .font(.system(size: 26, weight: .bold))

                        Text("Klinikleri keşfedin, randevunuzu kolayca oluşturun ve evcil dostunuz için faydalı içeriklere ulaşın.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 14)

                    featureCard(
                        icon: "house.fill",
                        title: "Klinikleri Gör",
                        desc: "Bulunduğunuz şehre göre klinikleri listeleyin, adres ve iletişim bilgilerine hızlıca ulaşın."
                    )

                    featureCard(
                        icon: "calendar.badge.clock",
                        title: "Randevu Oluştur",
                        desc: "Muayene türünü seçin, kliniği belirleyin ve uygun tarih/saat için randevunuzu planlayın."
                    )

                    featureCard(
                        icon: "book.pages.fill",
                        title: "Blog Yazıları Oku",
                        desc: "Bakım, beslenme ve sağlık konusunda veteriner önerileriyle güncel içeriklere ulaşın."
                    )

                    featureCard(
                        icon: "person.fill",
                        title: "Profil ve Randevu Geçmişi",
                        desc: "Profil bilgilerinizi yönetin, randevularınızı takip edin ve SSS bölümünden hızlı cevaplar alın."
                    )

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .customBackButton("Daha Fazla Bilgi")
        .toolbar(.visible, for: .navigationBar)
    }

    private func featureCard(icon: String, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.systemOrange))

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
            }

            Text(desc)
                .font(.system(size: 14))
                .foregroundStyle(.black.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.98))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    MoreInfoView()
}

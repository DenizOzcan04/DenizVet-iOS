//
//  FAQView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 21.12.2025.
//

import SwiftUI

struct FAQView: View {
    @State private var expandedIDs: Set<UUID> = []

    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)

    private let faqs: [FaqItem] = [
        // Genel
        FaqItem(
            question: "Evcil hayvanımın yıllık kontrolü ne sıklıkla yapılmalı?",
            answer: "Genel önerim yılda en az 1 kez rutin kontrol yapılmasıdır. 7 yaş ve üzeri (senior) hastalarda 6 ayda bir kontrol daha uygundur. Rutin muayenede kilo takibi, ağız-diş kontrolü, kalp-akciğer dinleme ve gerekli görülürse kan tahlilleri planlanır.",
            category: "Genel"
        ),
        FaqItem(
            question: "Aşı takvimini kaçırdım, yeniden mi başlamak gerekir?",
            answer: "Genelde tamamen başa dönmek gerekmez ama aşı tipine ve gecikme süresine göre rapel (pekiştirme) planı değişebilir. En doğrusu mevcut aşı kartına bakıp klinikte takvimi güncellemek. Özellikle karma aşı ve kuduz geciktiyse arayı fazla uzatmamak önemli.",
            category: "Genel"
        ),
        FaqItem(
            question: "Kedim/köpeğim iç parazit ve dış parazit uygulamasını ne sıklıkla almalı?",
            answer: "Çoğu evcil hayvanda dış parazit (pire-kene) aylık veya 3 aylık ürünlere göre değişir. İç parazit için genelde 2-3 ayda bir uygulama öneririm. Ancak evde çocuk olması, dışarı çıkma sıklığı, çiğ beslenme gibi durumlarda daha sık planlanabilir.",
            category: "Parazit"
        ),

        // Beslenme
        FaqItem(
            question: "Mamayı nasıl seçmeliyim? Tahılsız mama şart mı?",
            answer: "Tahılsız mama her zaman daha iyi demek değildir. Önemli olan hayvanın yaşı, kilo durumu, aktivitesi, hassasiyetleri (alerji/deri, sindirim) ve varsa hastalıklarıdır. Protein kaynağı, içerik kalitesi ve güvenilir marka daha belirleyicidir. Şüphede kalırsanız muayenede kilo–vücut kondisyonuna göre mama önerisi yapabiliriz.",
            category: "Beslenme"
        ),
        FaqItem(
            question: "Kedim az su içiyor, ne yapabilirim?",
            answer: "Kediler doğal olarak az su içebilir. Yaş mama eklemek, suyu farklı noktalara koymak, akışkan su pınarı kullanmak ve su kabını mamadan uzaklaştırmak işe yarar. Uzun süre az su içme + sık idrara çıkma/az idrar gibi belirtiler varsa böbrek ve idrar yolu açısından değerlendirmek gerekir.",
            category: "Beslenme"
        ),

        // Acil durum
        FaqItem(
            question: "Hangi durumlar acildir ve beklememeliyim?",
            answer: "Şunlarda beklemeyin: nefes darlığı, sürekli kusma/kanlı ishal, nöbet, bayılma, şiddetli halsizlik, gözde ani şişlik/yaralanma, idrar yapamama (özellikle erkek kediler), zehirlenme şüphesi, travma/düşme/araç çarpması, karında aşırı şişlik ve ağrı.",
            category: "Acil"
        ),
        FaqItem(
            question: "Zehirlenme şüphesinde evde ne yapmalıyım?",
            answer: "Önce panik yapmadan olası maddeyi uzaklaştırın ve mümkünse ambalajını saklayın. Kusturmaya çalışmayın (bazı zehirlerde daha zararlı olabilir). Hemen kliniğe veya en yakın acile ulaşın. Çikolata, üzüm-kuru üzüm, soğan-sarımsak, ksilitol, bazı ilaçlar ve temizlik ürünleri sık zehirlenme sebepleridir.",
            category: "Acil"
        ),

        // Randevu / Klinik
        FaqItem(
            question: "Randevuya gelirken yanımda ne getirmeliyim?",
            answer: "Varsa aşı karnesi, daha önceki tahlil/raporlar, kullandığı ilaçların listesi ve mama bilgisi çok yardımcı olur. Deri sorunu varsa son birkaç gün çekilmiş foto/video da tanıda işimizi kolaylaştırır.",
            category: "Randevu"
        ),
        FaqItem(
            question: "Muayene öncesi aç mı gelmeli?",
            answer: "Sadece muayene için aç gelmek şart değildir. Ancak kan tahlili/ameliyat veya sedasyon ihtimali varsa 8-10 saat açlık istenebilir. Randevu oluştururken not kısmına ‘tahlil planlanıyor mu?’ yazarsanız ona göre yönlendiririz.",
            category: "Randevu"
        ),

        // Kedi/Köpek davranış
        FaqItem(
            question: "Kedim kum kabı dışına yapmaya başladı, nedeni ne olabilir?",
            answer: "Bu durum hem davranışsal hem de tıbbi olabilir. İdrar yolu enfeksiyonu, kristal/taş, stres, kumun tipi, kabın yeri ve temizliği etkiler. Ani başladıysa ve sık tuvalete gidip az yapıyorsa mutlaka kontrol gerekir.",
            category: "Davranış"
        ),
        FaqItem(
            question: "Köpeğim sürekli kaşınıyor, pire görmüyorum ama neden olabilir?",
            answer: "Pireyi her zaman görmek kolay değildir; tek bir ısırık bile alerjik kaşıntı yapabilir. Bunun dışında gıda alerjisi, çevresel alerji (atopi), mantar, uyuz, cilt enfeksiyonları ve kulak problemleri de kaşıntı yapar. Muayenede deri-kulak kontrolü + gerekirse deri kazıntısı planlanır.",
            category: "Deri"
        )
    ]

    private var grouped: [(String, [FaqItem])] {
        let dict = Dictionary(grouping: faqs, by: { $0.category })
        return dict.keys.sorted().map { ($0, dict[$0] ?? []) }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    VStack(alignment: .leading, spacing: 6) {

                        Text("Veteriner hekim gözüyle en sık gelen soruları derledik.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    ForEach(grouped, id: \.0) { category, items in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.top, 6)

                            VStack(spacing: 10) {
                                ForEach(items) { item in
                                    faqCard(item)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding(.bottom, 24)
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(false)
        .customBackButton("Sıkça Sorulan Sorular")
    }

    @ViewBuilder
    private func faqCard(_ item: FaqItem) -> some View {
        let isOpen = expandedIDs.contains(item.id)

        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                    if isOpen { expandedIDs.remove(item.id) }
                    else { expandedIDs.insert(item.id) }
                }
            } label: {
                HStack(spacing: 10) {
                    Text(item.question)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.55))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isOpen {
                Text(item.answer)
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.98))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

#Preview {
    FAQView()
}

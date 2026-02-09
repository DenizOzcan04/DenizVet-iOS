import SwiftUI

struct ClinicCardView: View {
    let clinic: ClinicDTO

    @State private var showMap: Bool = false

    private let cardBg = Color.white.opacity(0.98)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(clinic.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)

                    Text("\(clinic.address) • \(clinic.city)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    StarRatingView(rating: clinic.safeAvgRating, size: 13)

                    Text(String(format: "%.1f", clinic.safeAvgRating) + " (\(clinic.safeRatingCount))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }

            if !clinic.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(clinic.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.black.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(.systemOrange))
                Text(clinic.phone.isEmpty ? "Telefon bilgisi yok" : clinic.phone)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                Spacer()
            }

            HStack {
                Spacer()

                Button {
                    showMap = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "map.fill")
                            
                        Text("Konumu Gör")
                            .foregroundStyle(.black)
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemOrange).opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .disabled(!clinic.hasLocation)
                .opacity(clinic.hasLocation ? 1 : 0.45)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBg)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
        )
        .sheet(isPresented: $showMap) {
            ClinicMapView(clinic: clinic)
        }
    }
}

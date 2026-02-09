import SwiftUI

struct HomeCard: View {
    var systemImage: String
    var title: String
    var isFeatured: Bool = false
    var action: () -> Void = {}

    private let iconBG      = Color(red: 1.0, green: 0.90, blue: 0.70).opacity(0.28)
    private let iconColor   = Color(red: 1.0, green: 0.70, blue: 0.28)
    private let cardBG      = Color.white

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(iconBG)
                    .frame(width: 46, height: 46)
                    .overlay(
                        Image(systemName: systemImage)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(iconColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )

                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.78))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.92)
            }
            .frame(width: 110, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(cardBG)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isFeatured ? Color(red: 1.0, green: 0.70, blue: 0.28).opacity(0.45) : Color.black.opacity(0.06),
                            lineWidth: isFeatured ? 1.2 : 1)
            )
            .shadow(color: .black.opacity(isFeatured ? 0.12 : 0.07),
                    radius: isFeatured ? 14 : 10, x: 0, y: isFeatured ? 10 : 8)
            .scaleEffect(isFeatured ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

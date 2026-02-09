import SwiftUI

struct GlobalTopBar: View {
    @Environment(\.dismiss) private var dismiss
    var showBack: Bool = false

    private let barBg = Color(red: 0.96, green: 0.78, blue: 0.60)

    var body: some View {
        HStack(spacing: 12) {

            if showBack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color.white.opacity(0.95)))
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            Text("DenizVet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.85))

            Spacer()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(barBg)
        .overlay(
            Rectangle()
                .fill(Color.black.opacity(0.06))
                .frame(height: 0.5),
            alignment: .bottom
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6) 
    }
}

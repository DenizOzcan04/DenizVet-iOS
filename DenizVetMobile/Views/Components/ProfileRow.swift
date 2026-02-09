import SwiftUI

struct ProfileRow: View {
    let systemIcon: String
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemOrange).opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: systemIcon)
                    .foregroundColor(Color(.systemOrange))
            }
            
            Text(title)
                .foregroundColor(.primary)
                .font(.system(size: 16))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
}

#Preview {
    ProfileRow(systemIcon: "person.fill", title: "Örnek")
}

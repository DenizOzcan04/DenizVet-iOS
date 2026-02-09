import SwiftUI

struct AppointmentCardView: View {
    let appointment: UserAppointmentDTO
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                    Text("\(appointment.date) • \(appointment.time)")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Text(statusText)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(statusColor.opacity(0.12))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(appointment.petName) • \(appointment.petType)")
                    .font(.system(size: 16, weight: .semibold))
                
                Text(appointment.serviceType)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            if let notes = appointment.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Button(role: .destructive) {
                onDelete()
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Randevuyu Sil")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.08))
                )
            }

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
    
    private var statusText: String {
        switch appointment.status {
        case "active": return "Onaylandı"
        case "pending": return "Beklemede"
        case "cancelled": return "İptal"
        default: return appointment.status.capitalized
        }
    }
    
    private var statusColor: Color {
        switch appointment.status {
        case "active": return Color.green
        case "pending": return Color.orange
        case "cancelled": return Color.red
        default: return Color.gray
        }
    }
}


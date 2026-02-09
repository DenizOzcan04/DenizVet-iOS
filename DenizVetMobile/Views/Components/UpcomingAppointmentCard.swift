//
//  UpcomingAppointmentCard.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 22.11.2025.
//

import SwiftUI

struct UpcomingAppointmentCard: View {
    let appointment: UserAppointmentDTO?
    var bookAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            Image("dogs-calendar") 
                .resizable()
                .scaledToFit()
                .frame(height: 160)
            
            if let appt = appointment {
                Text("Yaklaşan randevu")
                    .font(.system(size: 20, weight: .bold))
                
                Text("\(appt.petName) • \(appt.serviceType)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.85))
                
                if let clinicName = appt.clinic?.name {
                    Text(clinicName)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Text("\(formatTurkishDate(appt.date)) • \(formatTime(appt.time))")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
            } else {
                Text("Yaklaşan randevu yok")
                    .font(.system(size: 20, weight: .bold))
                
                Text("Evcil hayvanınızın mutlu ve sağlıklı kalması için bir randevu planlayın.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Button(action: bookAction) {
                    Text("Randevu Alın")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.25))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 1.0, green: 0.93, blue: 0.86))
                        )
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
}

private func formatTurkishDate(_ iso: String) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "tr_TR")
    df.dateFormat = "yyyy-MM-dd"

    guard let d = df.date(from: iso) else { return iso }

    let out = DateFormatter()
    out.locale = Locale(identifier: "tr_TR")
    out.dateFormat = "d MMMM yyyy"   // 16 Ocak 2026
    return out.string(from: d)
}

private func formatTime(_ t: String) -> String {
    if t.count >= 5 { return String(t.prefix(5)) }
    return t
}

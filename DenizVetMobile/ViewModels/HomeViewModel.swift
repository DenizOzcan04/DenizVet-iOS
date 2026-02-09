//
//  HomeViewModel.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 22.11.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var upcomingAppointment: UserAppointmentDTO? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var userName: String = ""
    
    func loadUpcomingAppointment() async {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            self.errorMessage = "Kullanıcı oturumu bulunamadı."
            self.upcomingAppointment = nil
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let all = try await AppointmentAPI.shared.fetchMyAppointments(token: token)
            let active = all.filter { $0.status == "active" }
            self.upcomingAppointment = active.first
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.upcomingAppointment = nil
        }
    }
    
    func loadUserName() async {
        do{
            let profile = try await ProfileAPI.shared.fetchProfile()
            self.userName = profile.name
        } catch {
            self.userName = ""
        }
    }
}


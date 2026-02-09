import Foundation

@MainActor
class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [UserAppointmentDTO] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func loadAppointments() async {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            self.errorMessage = "Kullanıcı oturumu bulunamadı."
            self.appointments = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let all = try await AppointmentAPI.shared.fetchMyAppointments(token: token)
            self.appointments = all.sorted { lhs, rhs in
                let leftKey = "\(lhs.date) \(lhs.time)"
                let rightKey = "\(rhs.date) \(rhs.time)"
                return leftKey < rightKey
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.appointments = []
        }
        
        isLoading = false
    }
    func deleteAppointment(_ appointment: UserAppointmentDTO) async {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                return
            }
            
            do {
                try await AppointmentAPI.shared.deleteAppointment(id: appointment.id, token: token)
                appointments.removeAll { $0.id == appointment.id }
            } catch {
                self.errorMessage = "Randevu silinirken bir hata oluştu."
            }
        }
    
    func refresh() async {
        await loadAppointments()
    }
}

import Foundation

@MainActor
final class VetAppointmentsViewModel: ObservableObject {
    @Published var appointments: [ClinicAppointmentDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadAppointments() async {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Oturum bilgisi bulunamadı. Lütfen tekrar giriş yapın."
            appointments = []
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            appointments = try await AppointmentAPI.shared.fetchClinicAppointments(token: token)
            errorMessage = nil
        } catch is CancellationError {
            return
        } catch let error as HTTPError {
            errorMessage = error.errorDescription ?? "Randevular alınamadı."
        } catch let error as URLError {
            if error.code == .cancelled {
                return
            }

            switch error.code {
            case .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .networkConnectionLost, .timedOut:
                errorMessage = "Sunucuya ulaşılamadı. Backend'in çalıştığından emin olun."
            default:
                errorMessage = "Bağlantı sırasında bir sorun oluştu."
            }
        } catch {
            errorMessage = "Randevular alınırken bir hata oluştu."
        }
    }
}

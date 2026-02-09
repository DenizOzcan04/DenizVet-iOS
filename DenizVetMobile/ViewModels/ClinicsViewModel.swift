import Foundation

@MainActor
final class ClinicsViewModel: ObservableObject {
    @Published var clinics: [ClinicDTO] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadClinics() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            clinics = try await ClinicsAPI.shared.fetchClinics()
        } catch let msg as ClinicAPIMessage {
            errorMessage = msg.message
        } catch {
            errorMessage = "Klinikler yüklenirken bir hata oluştu."
        }
    }
    
    func refresh() async {
        errorMessage = nil
        do {
            clinics = try await ClinicsAPI.shared.fetchClinics()
        } catch let msg as ClinicAPIMessage {
            errorMessage = msg.message
        } catch {
            errorMessage = "Klinikler yüklenirken bir hata oluştu."
        }
    }

}

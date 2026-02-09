import Foundation

struct ClinicsAPI {
    static let shared = ClinicsAPI()
    private init() {}

    private let baseURL = APIConfig.baseURL

    func fetchClinics() async throws -> [ClinicDTO] {
        let url = baseURL.appendingPathComponent("/api/clinics")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        req.setValue("no-cache", forHTTPHeaderField: "Pragma")


        let (data, resp) = try await URLSession.shared.data(for: req)

        guard let http = resp as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIMessage(message: "Klinikler alınamadı. (\(http.statusCode)) \(body)")
        }

        do {
            return try JSONDecoder().decode([ClinicDTO].self, from: data)
        } catch {
            throw APIMessage(message: "Klinik verisi çözümlenemedi.")
        }
    }
}

struct ClinicAPIMessage: Error {
    let message: String
}

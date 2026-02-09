//
//  AppointmentAPI.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 20.11.2025.
//
import Foundation

final class AppointmentAPI {
    static let shared = AppointmentAPI()
    
    private let baseURL = APIConfig.baseURL
    
    private init() {}
    
    func createAppointment(
        token: String,
        request: AppointmentRequest
    ) async throws -> AppointmentResponse {
        
        let url = baseURL.appendingPathComponent("/api/appointments")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code:", httpResponse.statusCode)
        
        let decoder = JSONDecoder()
        
        if (200..<300).contains(httpResponse.statusCode) {
            let result = try decoder.decode(AppointmentResponse.self, from: data)
            return result
        } else {
            let serverMessage = String(data: data, encoding: .utf8) ?? "Bilinmeyen hata"
            print("Server error:", serverMessage)
            throw NSError(
                domain: "AppointmentAPI",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: serverMessage]
            )
        }
    }
    // randevu çekme
    func fetchMyAppointments(token: String) async throws -> [UserAppointmentDTO] {
        let url = baseURL.appendingPathComponent("/api/appointments/my")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Pragma")

        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("My appointments status:", httpResponse.statusCode)
        
        let decoder = JSONDecoder()
        
        if (200..<300).contains(httpResponse.statusCode) {
            let list = try decoder.decode([UserAppointmentDTO].self, from: data)
            return list
        } else {
            let serverMessage = String(data: data, encoding: .utf8) ?? "Bilinmeyen hata"
            print("Server error (my appointments):", serverMessage)
            throw NSError(
                domain: "AppointmentAPI",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: serverMessage]
            )
        }
    }

    func deleteAppointment(id: String, token: String) async throws {
        var req = URLRequest(url: API.base.appendingPathComponent("/api/appointments/\(id)"))
        req.httpMethod = "DELETE"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, resp) = try await URLSession.shared.data(for: req)
        let status = (resp as? HTTPURLResponse)?.statusCode ?? 0
        
        guard (200..<300).contains(status) else {
            throw HTTPError.badStatus(status, "Randevu silinemedi.")
        }
    }

    
}

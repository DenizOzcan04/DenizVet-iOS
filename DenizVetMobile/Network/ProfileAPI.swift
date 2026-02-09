//
//  ProfileAPI.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 9.12.2025.
//


import Foundation

struct ProfileAPI {
    static let shared = ProfileAPI()
    
    private let baseURL = APIConfig.baseURL
    
    func fetchProfile() async throws -> UserDTO {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        print("PROFİLE GİDEN TOKEN:", token)   
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/auth/profile"))
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("/api/auth/profile statusCode:", httpResponse.statusCode)
        if let bodyString = String(data: data, encoding: .utf8) {
            print("/api/auth/profile body:", bodyString)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UserDTO.self, from: data)
    }
    
    func updateProfile(name: String, surname: String, phone: String) async throws -> UserDTO {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/auth/profile"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = UpdateProfileRequest(name: name, surname: surname, phone: phone)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("PUT /api/auth/profile statusCode:", httpResponse.statusCode)
        if let bodyString = String(data: data, encoding: .utf8) {
            print("PUT /api/auth/profile body:", bodyString)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIMessage.self, from: data) {
                throw HTTPError.badStatus(httpResponse.statusCode, apiError.message)
            }
            throw HTTPError.badStatus(httpResponse.statusCode, "Profil güncellenemedi.")
        }
        
        let responseObj = try JSONDecoder().decode(UpdateProfileResponse.self, from: data)
        return responseObj.user
    }
}




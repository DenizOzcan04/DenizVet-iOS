//
//  BlogAPI.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 25.11.2025.
//

import Foundation

struct BlogService {
    static let shared = BlogService()
    
    private let baseURL = APIConfig.baseURL
    
       func fetchBlogs() async throws -> [BlogModels] {
        let url = baseURL.appendingPathComponent("/api/blogs")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("/api/blogs statusCode:", httpResponse.statusCode)
        if let bodyString = String(data: data, encoding: .utf8) {
            print("/api/blogs body:", bodyString)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([BlogModels].self, from: data)
    }

}

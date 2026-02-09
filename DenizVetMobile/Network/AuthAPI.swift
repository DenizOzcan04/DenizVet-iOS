import Foundation

enum API {
    static let base = APIConfig.baseURL
}

enum HTTPError: Error, LocalizedError {
    case badStatus(Int, String)
    var errorDescription: String? {
        switch self {
        case .badStatus(let code, let msg): return "Hata (\(code)): \(msg)"
        }
    }
}

final class AuthAPI {
    static let shared = AuthAPI()
    private init() {}


    private func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        var req = URLRequest(url: API.base.appendingPathComponent(path))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        let status = (resp as? HTTPURLResponse)?.statusCode ?? 0

        if (200..<300).contains(status) {
            return try JSONDecoder().decode(T.self, from: data)
        } else {
            if let msg = try? JSONDecoder().decode(APIMessage.self, from: data) {
                throw HTTPError.badStatus(status, msg.message)
            }
            throw HTTPError.badStatus(status, "Bilinmeyen hata")
        }
    }


    func login(phone: String, password: String) async throws -> LoginResponse {
        try await post("/api/auth/login", body: LoginRequest(phone: phone, password: password))
    }


    func signup(name: String, surname: String, phone: String, password: String) async throws -> APIMessage {
        try await post("/api/auth/signup", body: SignupRequest(name: name, surname: surname, phone: phone, password: password))
    }
}


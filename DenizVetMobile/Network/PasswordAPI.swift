import Foundation

final class PasswordAPI {
    static let shared = PasswordAPI()
    private init() {}

    func changePassword(token: String, currentPassword: String, newPassword: String) async throws -> ChangePasswordResponse {
        let url = URL(string: API.base.absoluteString + "/api/auth/change-password")!
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpBody = try JSONEncoder().encode(
            ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword)
        )

        let (data, resp) = try await URLSession.shared.data(for: req)
        let status = (resp as? HTTPURLResponse)?.statusCode ?? 0

        if (200..<300).contains(status) {
            if let decoded = try? JSONDecoder().decode(ChangePasswordResponse.self, from: data) {
                return decoded
            }
            if let msg = try? JSONDecoder().decode(APIMessage.self, from: data) {
                return ChangePasswordResponse(message: msg.message)
            }
            return ChangePasswordResponse(message: "Şifre başarıyla güncellendi.")
        } else {
            if let msg = try? JSONDecoder().decode(APIMessage.self, from: data) {
                throw HTTPError.badStatus(status, msg.message)
            }
            throw HTTPError.badStatus(status, "Bilinmeyen hata")
        }
    }
}

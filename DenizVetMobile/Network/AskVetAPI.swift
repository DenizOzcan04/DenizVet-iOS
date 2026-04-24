import Foundation

final class AskVetAPI {
    static let shared = AskVetAPI()
    private init() {}

    func send(messages: [AskVetChatMessage], token: String) async throws -> AskVetChatResponse {
        var request = URLRequest(url: API.base.appendingPathComponent("/api/ask-vet/chat"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let payload = AskVetChatRequest(
            messages: messages.map { AskVetChatPayloadMessage(role: $0.role, content: $0.content) }
        )
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        if (200..<300).contains(status) {
            return try JSONDecoder().decode(AskVetChatResponse.self, from: data)
        }

        if let msg = try? JSONDecoder().decode(APIMessage.self, from: data) {
            throw HTTPError.badStatus(status, msg.message)
        }

        throw HTTPError.badStatus(status, "Veterinerime Sor servisine ulasilamadi.")
    }
}

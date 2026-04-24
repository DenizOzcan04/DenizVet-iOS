import Foundation

struct AskVetChatMessage: Codable, Identifiable, Hashable {
    let id: UUID
    let role: String
    let content: String

    init(id: UUID = UUID(), role: String, content: String) {
        self.id = id
        self.role = role
        self.content = content
    }
}

struct AskVetChatRequest: Encodable {
    let messages: [AskVetChatPayloadMessage]
}

struct AskVetChatPayloadMessage: Encodable {
    let role: String
    let content: String
}

struct AskVetChatResponse: Decodable {
    let message: String
    let answer: String
    let emergencyDetected: Bool?
    let matchedConditions: [String]?
}

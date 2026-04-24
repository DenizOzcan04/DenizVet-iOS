import Foundation

@MainActor
final class AskVetViewModel: ObservableObject {
    @Published var messages: [AskVetChatMessage] = [
        AskVetChatMessage(
            role: "assistant",
            content: "Merhaba, ben Veterinerime Sor AI. Evcil hayvanınla ilgili belirtileri yaz, ben de ön bilgilendirme yapayım."
        )
    ]
    @Published var inputText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func sendMessage() async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Oturum bulunamadi. Lutfen yeniden giris yap."
            return
        }

        let userMessage = AskVetChatMessage(role: "user", content: trimmed)
        messages.append(userMessage)
        inputText = ""
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await AskVetAPI.shared.send(messages: messages, token: token)
            messages.append(AskVetChatMessage(role: "assistant", content: response.answer))
        } catch let error as HTTPError {
            errorMessage = humanReadableError(from: error)
        } catch let error as URLError {
            errorMessage = humanReadableError(from: error)
        } catch {
            errorMessage = "Yanıt alınırken beklenmeyen bir sorun oluştu."
        }
    }

    func sendSuggestedPrompt(_ prompt: String) async {
        guard !isLoading else { return }
        inputText = prompt
        await sendMessage()
    }

    private func humanReadableError(from error: HTTPError) -> String {
        let raw = error.errorDescription?.lowercased() ?? ""

        if raw.contains("openai") || raw.contains("api anahtari") {
            return "AI servisi henuz tam hazir degil. Backend ayarlarini kontrol edip tekrar deneyelim."
        }

        return "Veterinerime Sor servisi şu an yanıt veremiyor. Lütfen birazdan tekrar dene."
    }

    private func humanReadableError(from error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .networkConnectionLost, .timedOut:
            return "Sunucuya ulasilamadi. Backend'in calistigindan emin olup tekrar dene."
        default:
            return "Baglanti sirasinda bir sorun olustu."
        }
    }
}

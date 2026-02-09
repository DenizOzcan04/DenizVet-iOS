import Foundation

@MainActor
final class PasswordSecurityViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorText: String?
    @Published var successText: String?

    func submit(token: String, current: String, new: String, again: String) async {
        errorText = nil
        successText = nil

        let c = current.trimmingCharacters(in: .whitespacesAndNewlines)
        let n = new.trimmingCharacters(in: .whitespacesAndNewlines)
        let a = again.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !c.isEmpty, !n.isEmpty, !a.isEmpty else {
            errorText = "Tüm alanlar zorunlu."
            return
        }
        guard n == a else {
            errorText = "Yeni şifreler aynı değil."
            return
        }
        guard n.count >= 6 else {
            errorText = "Şifre en az 6 karakter olmalı."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let resp = try await PasswordAPI.shared.changePassword(token: token, currentPassword: c, newPassword: n)
            successText = resp.message ?? "Şifre başarıyla güncellendi."
        } catch {
            errorText =
            (error as? LocalizedError)?.errorDescription ??
            (error as? APIMessage)?.message ??
            "Bilinmeyen hata"
        }
    }
}

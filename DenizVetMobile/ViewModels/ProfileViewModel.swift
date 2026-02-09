import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: UserDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?

    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    func loadProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            let profile = try await ProfileAPI.shared.fetchProfile()
            self.user = profile
        } catch {
            print("Profile fetch error:", error)
            self.errorMessage = "Profil bilgileri alınırken bir hata oluştu."
        }

        isLoading = false
    }

    func logout() {
        authToken = ""
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "currentUser")

        NotificationCenter.default.post(name: .didLogout, object: nil)
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}

extension UserDTO {
    var fullName: String {
        "\(name) \(surname)"
    }
}

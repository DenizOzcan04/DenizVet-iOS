import SwiftUI

struct AccountDetailsView: View {
    let user: UserDTO
    
    @State private var name: String
    @State private var surname: String
    @State private var email: String
    
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    init(user: UserDTO) {
        self.user = user
        _name = State(initialValue: user.name)
        _surname = State(initialValue: user.surname)
        _email = State(initialValue: user.email ?? "")
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.95, blue: 0.89)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color(.systemOrange))
                                )
                            
                            Text("\(name) \(surname)")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            infoRow(label: "Ad", text: $name, icon: "person.fill")
                            infoRow(label: "Soyad", text: $surname, icon: "person.fill")
                            infoRow(label: "Email", text: $email, icon: "envelope.fill", keyboard: .emailAddress)
                        }
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                        
                        if let successMessage {
                            Text(successMessage)
                                .foregroundColor(.green)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button {
                            Task { await saveChanges() }
                        } label: {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            } else {
                                Text("Bilgilerimi Düzenle")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemOrange))
                        )
                        .buttonStyle(.plain)
                        .disabled(isSaving)
                        
                    }
                    .padding(.vertical, 32)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton("Hesap Bilgileri")
    }

    private func infoRow(
        label: String,
        text: Binding<String>,
        icon: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(Color(.systemOrange))
                
                TextField(label, text: text)
                    .keyboardType(keyboard)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    private func saveChanges() async {
        errorMessage = nil
        successMessage = nil
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedName.isEmpty,
              !trimmedSurname.isEmpty,
              !trimmedEmail.isEmpty else {
            errorMessage = "Tüm alanlar zorunludur."
            return
        }

        guard trimmedEmail.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) != nil else {
            errorMessage = "Geçerli bir email adresi girin."
            return
        }
        
        isSaving = true
        defer { isSaving = false }
        
        do {
            let updatedUser = try await ProfileAPI.shared.updateProfile(
                name: trimmedName,
                surname: trimmedSurname,
                email: trimmedEmail
            )

            name = updatedUser.name
            surname = updatedUser.surname
            email = updatedUser.email ?? trimmedEmail
            
            successMessage = "Profiliniz başarıyla güncellendi."
        } catch {
            if let httpError = error as? HTTPError {
                errorMessage = httpError.localizedDescription
            } else if let apiMessage = error as? APIMessage {
                errorMessage = apiMessage.message
            } else {
                errorMessage = "Profil güncellenirken bir hata oluştu."
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccountDetailsView(
            user: UserDTO(id: "1", name: "Deniz", surname: "Özcan", email: "deniz@example.com", username: nil, role: "user", clinic: nil)
        )
    }
}

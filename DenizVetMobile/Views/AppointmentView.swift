//
//  AppointmentView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 27.10.2025.
//

import SwiftUI

struct AppointmentView: View {
    @State private var selectedType = "Kedi"
    let petTypes: [(name: String, icon: String)] = [
        ("Kedi", "pawprint.fill"),
        ("Köpek", "pawprint.fill"),
        ("Diğer", "ellipsis")
    ]

    @State private var petName: String = ""
    @State private var selectedReason = "Muayene"
    @State private var appointmentReasons = ["Muayene","Aşı","Tırnak Kesimi","Kısırlaştırma Operasyonu","Tüy Bakımı" ]

    // ✅ Klinikler artık API’dan gelecek
    @StateObject private var clinicsVM = ClinicsViewModel()

    @State private var clinicSelection = "Klinik Seçin"
    @State private var date: Date = .now
    @State private var notes: String = ""
    @State private var selectedTime: String = "09:00"

    @State private var isLoading = false
    @State private var infoMessage: String?
    @State private var showAlert = false

    @AppStorage("authToken") private var authToken: String = ""
    @State private var selectedClinicId: String? = nil

    var body: some View {
        ZStack {
            BackgroundViewAppointment()

            ScrollView {
                VStack {
                    AppointmentTitleView()
                    Spacer()

                    VStack(alignment: .leading) {

                        // evcil hayvan türü
                        Text("Evcil Hayvan Türü")
                            .font(.system(size: 17))
                            .padding(.top, 20)

                        HStack(spacing: 8) {
                            ForEach(petTypes, id: \.name) { pet in
                                PetTypeButton(type: pet.name, icon: pet.icon, selectedType: $selectedType)
                            }
                        }
                        .padding(.bottom, 20)

                        // evcil hayvan ismi
                        Text("Evcil Hayvanın İsmi")
                            .font(.system(size: 17))

                        TextField("Örn Maya", text: $petName)
                            .padding()
                            .autocorrectionDisabled()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.brown).opacity(0.7), lineWidth: 2)
                            )
                            .padding()

                        // randevu sebebi
                        Text("Randevu Sebebi")
                            .font(.system(size: 17))

                        Menu {
                            ForEach(appointmentReasons, id: \.self) { reason in
                                Button {
                                    selectedReason = reason
                                } label: {
                                    HStack {
                                        Text(reason)
                                        if reason == selectedReason {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedReason)
                                    .foregroundStyle(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color(.gray))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        .padding()

                        // ✅ klinik seçimi (dinamik)
                        Text("Klinik Seçimi")
                            .font(.system(size: 17))

                        Menu {
                            if clinicsVM.isLoading {
                                Text("Klinikler yükleniyor...")
                            } else if let err = clinicsVM.errorMessage {
                                Button("Tekrar dene") {
                                    Task { await clinicsVM.loadClinics() }
                                }
                                Text(err).foregroundStyle(.red)
                            } else if clinicsVM.clinics.isEmpty {
                                Text("Klinik bulunamadı.")
                            } else {
                                ForEach(clinicsVM.clinics) { clinic in
                                    Button {
                                        clinicSelection = clinic.name
                                        selectedClinicId = clinic.id
                                    } label: {
                                        HStack {
                                            Text(clinic.name)
                                            if clinic.id == selectedClinicId {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "building")
                                    .foregroundStyle(Color(.brown))
                                    .font(.system(size: 17))

                                Text(clinicSelection)
                                    .foregroundStyle(.black)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color(.gray))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        .padding()

                        // tarih
                        Text("Tarih")
                            .font(.system(size: 17))
                            .padding(.leading)
                            .padding(.top)

                        DatePicker("Tarih Seçin",
                                   selection: $date,
                                   displayedComponents: .date)
                        .font(GilroyFont(isBold: false, size: 15))
                        .padding(.leading)

                        // saat
                        Text("Saat")
                            .font(.system(size: 17))
                            .padding(.leading)
                            .padding(.top, 6)

                        Menu {
                            ForEach(timeSlots(), id: \.self) { t in
                                Button {
                                    selectedTime = t
                                } label: {
                                    HStack {
                                        Text(t)
                                        if t == selectedTime {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(Color(.brown))
                                    .font(.system(size: 17))
                                Text(selectedTime)
                                    .foregroundStyle(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color(.gray))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        .padding()

                        // ek not
                        Text("Ek Notlar (İsteğe bağlı)")
                            .font(.system(size: 17))
                            .padding(.leading)
                            .padding(.top)

                        TextField("Eklemek istediğiniz bir şey var mı ? ", text: $notes)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.brown).opacity(0.5), lineWidth: 2)
                            }
                            .padding()

                        // randevu al butonu
                        HStack {
                            Spacer()
                            Button {
                                handleAppointmentButton()
                            } label: {
                                Rectangle()
                                    .frame(width: 340, height: 54)
                                    .foregroundStyle(.clear)
                                    .background(Color(red: 0.96, green: 0.58, blue: 0.18))
                                    .cornerRadius(18)
                                    .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 12)
                                    .overlay {
                                        HStack {
                                            if isLoading {
                                                ProgressView()
                                                    .tint(.white)
                                                    .padding(.leading, 16)
                                            } else {
                                                Text("Randevu Al")
                                                    .foregroundStyle(.white)
                                                    .font(GilroyFont(isBold: true, size: 20))
                                                    .padding(.leading, 16)
                                            }

                                            Spacer()

                                            Image(systemName: "arrowshape.right.circle.fill")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundStyle(.white.opacity(0.95))
                                                .padding(.trailing, 16)
                                        }
                                    }
                            }
                            .disabled(isLoading)
                            .opacity(isLoading ? 0.85 : 1)
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 6)

                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                    )
                    .padding(.horizontal, 10)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .offset(y: 20)
                    .ignoresSafeArea(.all, edges: .bottom)

                    Spacer()
                }
                .padding(.top, 12)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bilgi"),
                message: Text(infoMessage ?? ""),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .task {
            await clinicsVM.loadClinics()
        }
    }

    private func resetForm() {
        selectedType = "Kedi"
        petName = ""
        selectedReason = "Muayene"
        clinicSelection = "Klinik Seçin"
        selectedClinicId = nil
        date = .now
        selectedTime = "09:00" 
        notes = ""
    }

    private func handleAppointmentButton() {
        print("Randevu butonuna basıldı")

        guard !authToken.isEmpty else {
            infoMessage = "Lütfen önce giriş yapın."
            showAlert = true
            return
        }

        guard !petName.trimmingCharacters(in: .whitespaces).isEmpty else {
            infoMessage = "Evcil hayvan ismi zorunludur."
            showAlert = true
            return
        }

        guard let clinicId = selectedClinicId else {
            infoMessage = "Lütfen bir klinik seçin."
            showAlert = true
            return
        }

        isLoading = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: date)
        let timeString = selectedTime

        let request = AppointmentRequest(
            petType: selectedType,
            petName: petName,
            serviceType: selectedReason,
            clinicId: clinicId,
            date: dateString,
            time: timeString,
            notes: notes.isEmpty ? nil : notes
        )

        Task {
            do {
                let response = try await AppointmentAPI.shared.createAppointment(
                    token: authToken,
                    request: request
                )

                infoMessage = response.message
                showAlert = true
                resetForm()

            } catch {
                print("Randevu hatası:", error.localizedDescription)
                infoMessage = "Randevu oluşturulurken bir hata oluştu."
                showAlert = true
            }

            isLoading = false
        }
    }
}

// MARK: - Helpers

@ViewBuilder
func BackgroundViewAppointment() -> some View {
    Color(red: 0.97, green: 0.95, blue: 0.89)
        .ignoresSafeArea()
}

@ViewBuilder
func AppointmentTitleView() -> some View {
    Text("Randevu Al")
        .font(GilroyFont(isBold: true, size: 26))
        .foregroundStyle(.black)
        .opacity(0.7)

    Text("Evcil dostun için hızlıca randevu oluştur")
        .font(GilroyFont(isBold: false, size: 17))
        .foregroundStyle(.black)
        .opacity(0.8)
}

func timeSlots() -> [String] {
    var out: [String] = []
    for h in 9...19 {
        out.append(String(format: "%02d:00", h))
        if h != 19 { out.append(String(format: "%02d:30", h)) }
    }
    return out
}

struct PetTypeButton: View {
    let type: String
    let icon: String
    @Binding var selectedType: String

    var isSelected: Bool { selectedType == type }

    var body: some View {
        Button(action: { selectedType = type }) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(type)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color(red: 0.98, green: 0.61, blue: 0.44) : Color.white)
            )
            .foregroundColor(isSelected ? .white : .gray)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    AppointmentView()
}

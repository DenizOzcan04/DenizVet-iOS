//
//  ClinicsView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 22.11.2025.
//

import SwiftUI

struct ClinicsView: View {
    @StateObject private var vm = ClinicsViewModel()
    @State private var query: String = ""

    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)

    private var filtered: [ClinicDTO] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return vm.clinics }
        return vm.clinics.filter {
            $0.name.lowercased().contains(q) ||
            $0.city.lowercased().contains(q) ||
            $0.address.lowercased().contains(q)
        }
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {

                        Text("Size en yakın kliniği seçin ve randevunuzu oluşturun.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField("Klinik ara (isim, şehir, adres)", text: $query)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.9))
                    )

                    if vm.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Klinikler yükleniyor...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                    } else if let error = vm.errorMessage {
                        VStack(spacing: 12) {
                            Text(error)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)

                            Button("Tekrar dene") {
                                Task { await vm.loadClinics() }
                            }
                            .font(.system(size: 15, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(filtered) { clinic in
                                ClinicCardView(clinic: clinic)
                            }
                        }
                        .padding(.top, 6)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
            .refreshable {
                await vm.refresh()
            }
        }
        .customBackButton("Klinikler")
        .task {
            await vm.loadClinics()
        }
    }
}

#Preview {
    ClinicsView()
}


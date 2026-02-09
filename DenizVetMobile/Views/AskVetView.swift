//
//  AskVetView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 11.01.2026.
//

import SwiftUI

struct AskVetView: View {
    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 14) {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 86, height: 86)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(Color(.systemOrange))
                    )

                Text("Veterinerime Sor")
                    .font(.system(size: 22, weight: .bold))

                Text("Yakında AI Vet Danışmanı hizmetimiz devreye alınacaktır.\nŞimdilik randevu alarak uzman doktorlarımıza ulaşabilirsiniz.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 22)

                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white)
                    .frame(height: 220)
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Chat arayüzü (yakında)")
                                .font(.system(size: 15, weight: .semibold))

                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .frame(height: 44)
                                .overlay(
                                    HStack {
                                        Text("Sorunuzu yazın...")
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Image(systemName: "paperplane.fill")
                                            .foregroundStyle(Color(.systemOrange))
                                    }
                                    .padding(.horizontal, 14)
                                )

                            Spacer()
                        }
                        .padding(16)
                    )
                    .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 22)
        }
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton("Veterinerime Sor")
    }
}

#Preview {
    AskVetView()
}


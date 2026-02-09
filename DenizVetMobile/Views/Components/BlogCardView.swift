//
//  BlogCardView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 25.11.2025.
//


import SwiftUI

struct BlogCardView: View {
    let blog: BlogModels
    
    private var formattedDate: String {
        let s = blog.publishedAt.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return "" }

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: s) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: date)
        }

        let iso2 = ISO8601DateFormatter()
        iso2.formatOptions = [.withInternetDateTime]
        if let date = iso2.date(from: s) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: date)
        }

        return ""
    }
    
   
    private var primaryOrange: Color {
        Color("PrimaryOrange")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let urlString = blog.imageUrl,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 200)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            // içerik kısmı
            VStack(alignment: .leading, spacing: 8) {
                Text(blog.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text(blog.excerpt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                

                HStack(spacing: 10) {

                    if !formattedDate.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary.opacity(0.9))
                            Text(formattedDate)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }

                    if !formattedDate.isEmpty {
                        Text("•")
                            .font(.footnote)
                            .foregroundColor(.secondary.opacity(0.8))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary.opacity(0.9))
                        Text("\(blog.readTime) dk okuma")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Devamını Oku butonu
                    HStack(spacing: 6) {
                        Text("Devamını Oku")
                            .font(.footnote.weight(.semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(.black.opacity(0.75))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        Capsule()
                            .fill(primaryOrange.opacity(0.22))
                    )
                    .overlay(
                        Capsule()
                            .stroke(primaryOrange.opacity(0.25), lineWidth: 1)
                    )
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

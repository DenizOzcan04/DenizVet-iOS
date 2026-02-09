//
//  BlogDetailView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 25.11.2025.
//

import SwiftUI

struct BlogDetailView: View {
    let blog: BlogModels
    
    var body: some View {
        ZStack{
            Color(red: 0.97, green: 0.95, blue: 0.89)
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    if let urlString = blog.imageUrl,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 240)
                                    .clipped()
                            default:
                                Color(.systemGray5)
                                    .frame(height: 240)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }
                    
                    Text(blog.title)
                        .font(.title.bold())
                    
                    Text(blog.content)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            
            .navigationTitle("Blog")
            .navigationBarTitleDisplayMode(.inline)
            .customBackButton("Blog")
        }
    }
}


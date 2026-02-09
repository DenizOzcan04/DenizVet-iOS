//
//  StarRatingView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 21.12.2025.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let maxStars: Int = 5
    let size: CGFloat

    init(rating: Double, size: CGFloat = 14) {
        self.rating = rating
        self.size = size
    }

    var body: some View {
        let filled = Int(round(rating))
        HStack(spacing: 3) {
            ForEach(1...maxStars, id: \.self) { index in
                Image(systemName: index <= filled ? "star.fill" : "star")
                    .font(.system(size: size, weight: .semibold))
                    .foregroundStyle(Color(.systemOrange))
            }
        }
    }
}

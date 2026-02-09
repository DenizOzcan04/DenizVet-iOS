//
//  BlogModels.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 25.11.2025.
//

import Foundation

struct BlogModels: Identifiable, Codable {
    let _id: String
    var id: String { _id }

    let title: String
    let excerpt: String
    let content: String
    let imageUrl: String?
    let publishedAt: String
    let readTime: Int
}

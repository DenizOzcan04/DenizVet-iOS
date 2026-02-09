//
//  FaqItem.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 21.12.2025.
//

import Foundation

struct FaqItem: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String
    let category: String
}

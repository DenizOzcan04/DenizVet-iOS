//
//  ClinicDTO.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 21.12.2025.
//

import Foundation
import CoreLocation

struct ClinicDTO: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let city: String
    let phone: String
    let description: String
    let avgRating: Double?
    let ratingCount: Int?
    let lat: Double?
    let lng: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, city, phone, description, avgRating, ratingCount, lat, lng
    }

    var safeAvgRating: Double { avgRating ?? 0 }
    var safeRatingCount: Int { ratingCount ?? 0 }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat, let lng else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var hasLocation: Bool {
        coordinate != nil
    }
    
}

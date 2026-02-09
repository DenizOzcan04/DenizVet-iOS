//
//  AppointmentModels.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 20.11.2025.
//

import Foundation

struct AppointmentRequest: Codable {
    let petType: String
    let petName: String
    let serviceType: String
    let clinicId: String
    let date: String
    let time: String
    let notes: String?
}

struct AppointmentResponse: Codable {
    let message: String
    let appointment: AppointmentDTO?
}


struct AppointmentDTO: Codable {
    let id: String
    let user: String
    let clinic: String
    let petType: String
    let petName: String
    let serviceType: String
    let date: String
    let time: String
    let notes: String?
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case clinic
        case petType
        case petName
        case serviceType
        case date
        case time
        case notes
        case status
    }
}

// Klinik 
struct ClinicSummaryDTO: Codable {
    let id: String
    let name: String
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
    }
}


struct UserAppointmentDTO: Codable, Identifiable {
    let id: String
    let petType: String
    let petName: String
    let serviceType: String
    let date: String
    let time: String
    let notes: String?
    let status: String
    let clinic: ClinicSummaryDTO?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case petType
        case petName
        case serviceType
        case date
        case time
        case notes
        case status
        case clinic
    }
}


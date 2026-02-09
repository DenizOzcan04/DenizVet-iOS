import Foundation

struct LoginRequest: Encodable {
    let phone: String
    let password: String
}

struct SignupRequest: Encodable {
    let name: String
    let surname: String
    let phone: String
    let password: String
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let surname: String
    let phone: String
    let role: String?
}

struct LoginResponse: Decodable {
    let message: String
    let token: String
    let user: UserDTO
}

struct APIMessage: Decodable, Error {
    let message: String
}

struct UpdateProfileRequest: Encodable {
    let name: String
    let surname: String
    let phone: String
}

struct UpdateProfileResponse: Decodable {
    let message: String
    let user: UserDTO
}

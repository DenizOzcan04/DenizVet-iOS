import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignupRequest: Encodable {
    let name: String
    let surname: String
    let email: String
    let password: String
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let surname: String
    let email: String?
    let username: String?
    let role: String?
    let clinic: String?
}

struct LoginResponse: Decodable {
    let message: String
    let token: String
    let user: UserDTO
}

struct VetLoginRequest: Encodable {
    let username: String
    let password: String
}

struct APIMessage: Decodable, Error {
    let message: String
}

struct UpdateProfileRequest: Encodable {
    let name: String
    let surname: String
    let email: String
}

struct UpdateProfileResponse: Decodable {
    let message: String
    let user: UserDTO
}

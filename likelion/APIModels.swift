import Foundation

// MARK: - API Response Models

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: UserResponse
}

struct SignupResponse: Codable {
    let message: String
    let token: String
    let user: UserResponse
}

struct UserResponse: Codable {
    let id: String
    let email: String
    let name: String
    let university: String
    let major: String?
    let graduation_year: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case university
        case major
        case graduation_year
        case bio
    }
}

struct ErrorResponse: Codable {
    let message: String
}

// MARK: - Activity Models

struct ActivityResponse: Codable {
    let message: String
    let activity: ActivityData
}

struct ActivitiesResponse: Codable {
    let activities: [ActivityData]
}

struct ActivityData: Codable {
    let id: String
    let title: String
    let category: String
    let description: String
    let hostUserId: String
    let hostName: String
    let locationName: String
    let locationLat: Double
    let locationLng: Double
    let startDateTime: Date
    let endDateTime: Date?
    let isInstant: Bool
    let maxParticipants: Int
    let currentParticipants: Int
    let status: String
    let participants: [String]
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category
        case description
        case hostUserId = "hostUserId"
        case hostName = "hostName"
        case locationName = "locationName"
        case locationLat = "locationLat"
        case locationLng = "locationLng"
        case startDateTime = "startDateTime"
        case endDateTime = "endDateTime"
        case isInstant = "isInstant"
        case maxParticipants = "maxParticipants"
        case currentParticipants = "currentParticipants"
        case status
        case participants
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}

// MARK: - API Error

enum APIError: LocalizedError {
    case invalidURL
    case networkError(String)
    case decodingError(String)
    case serverError(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .networkError(let message):
            return "Network connection failed: \(message)"
        case .decodingError(let message):
            return "Failed to parse response: \(message)"
        case .serverError(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}

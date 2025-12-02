import Foundation

class APIService {
    static let shared = APIService()

    private let baseURL = "http://10.239.255.73:3000"
    private let timeoutInterval: TimeInterval = 7.0

    // MARK: - Signup
    func signup(
        email: String,
        password: String,
        name: String,
        university: String
    ) async throws -> SignupResponse {
        let endpoint = "/api/auth/signup"
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "email": email,
            "password": password,
            "name": name,
            "university": university
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        let signupResponse = try decoder.decode(SignupResponse.self, from: data)
        return signupResponse
    }

    // MARK: - Login
    func login(
        email: String,
        password: String
    ) async throws -> LoginResponse {
        let endpoint = "/api/auth/login"
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
        return loginResponse
    }

    // MARK: - Update Profile
    func updateProfile(
        userId: String,
        major: String,
        graduationYear: String,
        bio: String
    ) async throws -> LoginResponse {
        let endpoint = "/api/auth/profile/\(userId)"
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String?] = [
            "major": major.isEmpty ? nil : major,
            "graduation_year": graduationYear.isEmpty ? nil : graduationYear,
            "bio": bio.isEmpty ? nil : bio
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
        return loginResponse
    }

    // MARK: - Create Activity
    func createActivity(
        title: String,
        category: String,
        description: String,
        hostUserId: String,
        hostName: String,
        locationName: String,
        locationLat: Double,
        locationLng: Double,
        startDateTime: Date,
        endDateTime: Date?,
        maxParticipants: Int
    ) async throws -> ActivityResponse {
        let endpoint = "/api/activities"
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dateFormatter = ISO8601DateFormatter()
        let body: [String: Any] = [
            "title": title,
            "category": category,
            "description": description,
            "hostUserId": hostUserId,
            "hostName": hostName,
            "locationName": locationName,
            "locationLat": locationLat,
            "locationLng": locationLng,
            "startDateTime": dateFormatter.string(from: startDateTime),
            "endDateTime": endDateTime != nil ? dateFormatter.string(from: endDateTime!) : NSNull(),
            "maxParticipants": maxParticipants
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let activityResponse = try decoder.decode(ActivityResponse.self, from: data)
        return activityResponse
    }

    // MARK: - Fetch Activities
    func fetchActivities(category: String? = nil) async throws -> [ActivityData] {
        let endpoint = "/api/activities"
        var urlString = baseURL + endpoint

        if let category = category {
            urlString += "?category=\(category)"
        }

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeoutInterval

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let activitiesResponse = try decoder.decode(ActivitiesResponse.self, from: data)
        return activitiesResponse.activities
    }

    // MARK: - Join Activity
    func joinActivity(activityId: String, userId: String) async throws -> ActivityResponse {
        let endpoint = "/api/activities/\(activityId)/join"
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "userId": userId
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        try handleResponse(response, data: data)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let activityResponse = try decoder.decode(ActivityResponse.self, from: data)
        return activityResponse
    }

    // MARK: - Helper Methods

    private func handleResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown("Invalid response")
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400:
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.serverError(errorResponse.message)
        case 401:
            throw APIError.serverError("Invalid email or password")
        case 409:
            throw APIError.serverError("Email already registered")
        case 500...599:
            throw APIError.serverError("Server error. Please try again later.")
        default:
            throw APIError.serverError("An error occurred. Status code: \(httpResponse.statusCode)")
        }
    }
}

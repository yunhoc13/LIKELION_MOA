import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var authScreen: AuthScreen = .login
    @Published var isProfileSetupComplete = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = APIService.shared
    private let keychainManager = KeychainManager.shared

    enum AuthScreen {
        case login
        case signup
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiService.login(email: email, password: password)

            // Save token to Keychain
            keychainManager.saveToken(response.token)

            // Update user state
            currentUser = User(
                id: response.user.id,
                email: response.user.email,
                name: response.user.name,
                university: response.user.university,
                major: response.user.major,
                graduationYear: response.user.graduation_year,
                bio: response.user.bio
            )

            // Check if profile is complete (has major or bio filled in)
            isProfileSetupComplete = (response.user.major != nil && !response.user.major!.isEmpty) ||
                                     (response.user.bio != nil && !response.user.bio!.isEmpty)

            isLoggedIn = true
            isLoading = false
        } catch {
            isLoading = false
            if let apiError = error as? APIError {
                errorMessage = apiError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }

    func signup(email: String, password: String, name: String, university: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiService.signup(
                email: email,
                password: password,
                name: name,
                university: university
            )

            // Save token to Keychain
            keychainManager.saveToken(response.token)

            // On successful signup, show message and redirect to login
            // User will login manually
            isLoading = false
            errorMessage = nil
            // Don't log in automatically - let user login manually
        } catch {
            isLoading = false
            if let apiError = error as? APIError {
                errorMessage = apiError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        authScreen = .login
        isProfileSetupComplete = false
        keychainManager.deleteToken()
    }

    func switchToSignup() {
        authScreen = .signup
        errorMessage = nil
    }

    func switchToLogin() {
        authScreen = .login
        errorMessage = nil
    }

    func completeProfileSetup(nickname: String, major: String, graduationYear: String, bio: String) async {
        guard let user = currentUser else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await apiService.updateProfile(
                userId: user.id,
                major: major,
                graduationYear: graduationYear,
                bio: bio
            )

            // Update current user with profile info
            currentUser = User(
                id: response.user.id,
                email: response.user.email,
                name: nickname,
                university: response.user.university,
                major: response.user.major,
                graduationYear: response.user.graduation_year,
                bio: response.user.bio
            )

            isProfileSetupComplete = true
            isLoading = false
        } catch {
            isLoading = false
            if let apiError = error as? APIError {
                errorMessage = apiError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct User: Identifiable {
    let id: String
    let email: String
    let name: String
    let university: String
    let major: String?
    let graduationYear: String?
    let bio: String?

    init(id: String, email: String, name: String, university: String, major: String? = nil, graduationYear: String? = nil, bio: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.university = university
        self.major = major
        self.graduationYear = graduationYear
        self.bio = bio
    }
}

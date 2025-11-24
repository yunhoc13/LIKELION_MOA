import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var authScreen: AuthScreen = .login
    @Published var isProfileSetupComplete = false

    enum AuthScreen {
        case login
        case signup
    }

    func login(email: String, password: String) {
        // TODO: Implement actual authentication with backend
        currentUser = User(
            id: "1",
            email: email,
            name: "User",
            university: "Boston University"
        )
        isLoggedIn = true
    }

    func signup(email: String, password: String, name: String, university: String) {
        // TODO: Implement actual signup with backend
        // After signup, don't log in automatically - user must sign in manually
        // Just store the user data (in a real app, you'd save to backend)
        // Then show success alert and redirect to login
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        authScreen = .login
    }

    func switchToSignup() {
        authScreen = .signup
    }

    func switchToLogin() {
        authScreen = .login
    }

    func completeProfileSetup(nickname: String, major: String, graduationYear: String, bio: String) {
        // Update current user with profile info
        if let user = currentUser {
            currentUser = User(
                id: user.id,
                email: user.email,
                name: nickname,
                university: user.university,
                major: major,
                graduationYear: graduationYear,
                bio: bio
            )
        }
        isProfileSetupComplete = true
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

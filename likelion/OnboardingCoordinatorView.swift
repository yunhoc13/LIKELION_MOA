import SwiftUI

struct OnboardingCoordinatorView: View {
    @EnvironmentObject var appState: AppState

    let userId: String
    let userName: String
    let userEmail: String
    let userUniversity: String

    @State private var currentStep: OnboardingStep = .profile
    @State private var selectedCategories: [InterestCategory] = []
    @State private var selectedSubcategories: [String] = []
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    // Profile info
    @State private var major: String = ""
    @State private var graduationYear: String = ""
    @State private var bio: String = ""

    enum OnboardingStep {
        case profile
        case categories
        case subcategories
    }

    var body: some View {
        ZStack {
            // Main content
            Group {
                switch currentStep {
                case .profile:
                    OnboardingProfileView(
                        major: $major,
                        graduationYear: $graduationYear,
                        bio: $bio,
                        onContinue: {
                            saveProfileAndContinue()
                        },
                        onSkip: {
                            currentStep = .categories
                        }
                    )

                case .categories:
                    CategorySelectionView(
                        selectedCategories: $selectedCategories,
                        onContinue: {
                            currentStep = .subcategories
                        }
                    )

                case .subcategories:
                    SubcategorySelectionView(
                        selectedCategories: selectedCategories,
                        selectedSubcategories: $selectedSubcategories,
                        onComplete: {
                            saveInterestsAndComplete()
                        }
                    )
                }
            }
            .disabled(isLoading)

            // Loading overlay
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)

                    Text("Setting up your profile...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(24)
                .background(Color.black.opacity(0.7))
                .cornerRadius(12)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func saveProfileAndContinue() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let response = try await APIService.shared.updateProfile(
                    userId: userId,
                    major: major,
                    graduationYear: graduationYear,
                    bio: bio
                )

                // Update app state with new user data
                appState.token = response.token

                // Move to next step
                await MainActor.run {
                    currentStep = .categories
                }

            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private func saveInterestsAndComplete() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let categoryIds = selectedCategories.map { $0.id }
                let response = try await APIService.shared.updateInterests(
                    userId: userId,
                    categories: categoryIds,
                    subcategories: selectedSubcategories
                )

                // Update app state
                appState.token = response.token

                // Update user with new info
                await MainActor.run {
                    appState.currentUser = User(
                        id: userId,
                        email: userEmail,
                        name: userName,
                        university: userUniversity,
                        major: major.isEmpty ? nil : major,
                        graduationYear: graduationYear.isEmpty ? nil : graduationYear,
                        bio: bio.isEmpty ? nil : bio
                    )
                    appState.isLoggedIn = true
                }

            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

// Onboarding Profile Setup View
struct OnboardingProfileView: View {
    @Binding var major: String
    @Binding var graduationYear: String
    @Binding var bio: String
    let onContinue: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us about yourself")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)

                Text("Help others get to know you better (optional)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.white)

            // Form
            ScrollView {
                VStack(spacing: 16) {
                    // Major
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Major / Field of Study")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)

                        TextField("e.g., Computer Science", text: $major)
                            .font(.system(size: 15))
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }

                    // Graduation Year
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Graduation Year")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)

                        TextField("e.g., 2025", text: $graduationYear)
                            .font(.system(size: 15))
                            .keyboardType(.numberPad)
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }

                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)

                        TextEditor(text: $bio)
                            .font(.system(size: 15))
                            .frame(height: 100)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )

                        if bio.isEmpty {
                            Text("Tell us a bit about yourself, your interests, or what you're looking for...")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.top, -90)
                                .padding(.leading, 14)
                                .allowsHitTesting(false)
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGray6))

            // Buttons
            VStack(spacing: 0) {
                Divider()

                VStack(spacing: 12) {
                    // Skip button
                    Button(action: onSkip) {
                        Text("Skip for now")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                    }

                    // Continue button
                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                            .cornerRadius(10)
                    }
                }
                .padding(16)
                .background(Color.white)
            }
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    OnboardingCoordinatorView(
        userId: "123",
        userName: "Test User",
        userEmail: "test@example.com",
        userUniversity: "Test University"
    )
    .environmentObject(AppState())
}

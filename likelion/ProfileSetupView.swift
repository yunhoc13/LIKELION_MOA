import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var appState: AppState
    @State private var nickname: String = ""
    @State private var major: String = ""
    @State private var graduationYear: String = ""
    @State private var bio: String = ""
    @State private var profilePhoto: UIImage? = nil
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Complete Your Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                Text("Just a few more details to get started")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 16) {
                    // Profile Photo (Optional)
                    VStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Color(red: 0.4, green: 0.3, blue: 0.8).opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("📷")
                                    .font(.system(size: 40))
                            )

                        Button(action: {
                            // TODO: Implement image picker
                        }) {
                            Text("Upload Photo (Optional)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)

                    // Nickname / Display Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nickname / Display Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextField("Enter your nickname", text: $nickname)
                            .textInputAutocapitalization(.words)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Major / Department
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Major / Department")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextField("e.g., Computer Science", text: $major)
                            .textInputAutocapitalization(.words)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Graduation Year
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Graduation Year")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextField("e.g., 2025", text: $graduationYear)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Bio / Introduction
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio / Introduction (Optional)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Error message from local validation or API
                    if let errorMessage = errorMessage ?? appState.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.red)
                    }
                }
            }

            Spacer()

            // Finish Setup Button
            Button(action: handleFinishSetup) {
                if appState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8).opacity(0.7))
                        .cornerRadius(8)
                } else {
                    Text("Finish Setup")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .cornerRadius(8)
                }
            }
            .disabled(appState.isLoading)

            // Skip for now button
            Button(action: {
                Task {
                    await appState.completeProfileSetup(
                        nickname: appState.currentUser?.name ?? "User",
                        major: "",
                        graduationYear: "",
                        bio: ""
                    )
                }
            }) {
                Text("Skip for now")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
            }
            .disabled(appState.isLoading)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
    }

    private func handleFinishSetup() {
        if nickname.isEmpty {
            errorMessage = "Nickname is required"
            return
        }

        errorMessage = nil

        Task {
            await appState.completeProfileSetup(
                nickname: nickname,
                major: major,
                graduationYear: graduationYear,
                bio: bio
            )
        }
    }
}

#Preview {
    ProfileSetupView()
        .environmentObject(AppState())
}

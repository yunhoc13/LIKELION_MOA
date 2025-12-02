import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("MOA")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                Text("Meet On App")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)

            Spacer()

            // Email field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)

                TextField("Enter your email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            // Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)

                HStack {
                    if showPassword {
                        TextField("Enter your password", text: $password)
                            .textInputAutocapitalization(.never)
                    } else {
                        SecureField("Enter your password", text: $password)
                            .textInputAutocapitalization(.never)
                    }

                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            // Error message from local validation or API
            if let errorMessage = errorMessage ?? appState.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.red)
            }

            Spacer()

            // Login button
            Button(action: {
                // Dismiss keyboard first
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                handleLogin()
            }) {
                if appState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8).opacity(0.7))
                        .cornerRadius(8)
                } else {
                    Text("Sign In")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .cornerRadius(8)
                }
            }
            .disabled(appState.isLoading)
    
    

            // Sign up link
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)

                Button(action: {
                    appState.switchToSignup()
                }) {
                    Text("Sign Up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
    }

    private func handleLogin() {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            return
        }

        errorMessage = nil

        Task {
            await appState.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}

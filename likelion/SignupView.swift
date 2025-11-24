import SwiftUI

struct SignupView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var name: String = ""
    @State private var university: String = ""
    @State private var showPassword: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showSuccessAlert: Bool = false
    @State private var agreeToTerms: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                Text("Join MOA today")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 16) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextField("Enter your name", text: $name)
                            .textInputAutocapitalization(.words)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

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

                    // University field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("University")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        TextField("e.g., Boston University", text: $university)
                            .textInputAutocapitalization(.words)
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

                    // Confirm password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        HStack {
                            if showPassword {
                                TextField("Confirm password", text: $confirmPassword)
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Confirm password", text: $confirmPassword)
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

                    // Error message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.red)
                    }
                }
            }

            Spacer()

            // Terms & Conditions
            HStack(spacing: 8) {
                Button(action: { agreeToTerms.toggle() }) {
                    Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }

                Text("I agree to the Terms & Conditions")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding(12)

            // Sign up button
            Button(action: handleSignup) {
                Text("Create Account")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                    .cornerRadius(8)
            }

            // Sign in link
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)

                Button(action: {
                    appState.switchToLogin()
                }) {
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .alert("Sign Up Successful", isPresented: $showSuccessAlert) {
            Button("OK") {
                // Confirm and switch back to login screen
                appState.switchToLogin()
            }
        } message: {
            Text("Your account has been created. Please sign in to continue.")
        }
    }

    private func handleSignup() {
        print("handleSignup called")

        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || university.isEmpty {
            print("Some fields are empty")
            errorMessage = "Please fill in all fields"
            return
        }

        if !email.contains("@") {
            print("Invalid email")
            errorMessage = "Please enter a valid email"
            return
        }

        if password != confirmPassword {
            print("Passwords don't match")
            errorMessage = "Passwords don't match"
            return
        }

        if password.count < 6 {
            print("Password too short")
            errorMessage = "Password must be at least 6 characters"
            return
        }

        if !agreeToTerms {
            print("User didn't agree to terms")
            errorMessage = "Please agree to Terms & Conditions"
            return
        }

        print("Signup validation passed, creating account")
        errorMessage = nil
        appState.signup(email: email, password: password, name: name, university: university)
        // The signup function sets isLoggedIn = true, so user goes directly to home
        showSuccessAlert = true
    }
}

#Preview {
    SignupView()
        .environmentObject(AppState())
}

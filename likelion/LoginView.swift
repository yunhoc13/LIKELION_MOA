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

            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.red)
            }

            Spacer()

            // Login button
            Button(action: {
                // Dismiss keyboard first
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                print("DEBUG: Button tapped!")
                handleLogin()
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                    .cornerRadius(8)
            }
            .simultaneousGesture(TapGesture().onEnded {
                print("DEBUG: Simultaneous gesture detected!")
            })
    
    

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
        print("handleLogin called with email: \(email), password: \(password)")

        if email.isEmpty || password.isEmpty {
            print("Email or password is empty")
            errorMessage = "Please fill in all fields"
            return
        }

        print("Login validation passed, calling appState.login")
        errorMessage = nil
        print("About to set isLoggedIn to true")
        appState.login(email: email, password: password)
        print("isLoggedIn is now: \(appState.isLoggedIn)")
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}

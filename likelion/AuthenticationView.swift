import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.authScreen == .login {
            LoginView()
                
        } else {
            SignupView()
                
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AppState())
}

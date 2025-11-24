import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @EnvironmentObject var appState: AppState

    var body: some View {
        if isActive {
            AuthenticationView()
                .environmentObject(appState)
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.98, blue: 1.0),
                        Color(red: 0.95, green: 0.95, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // MOA Logo Text
                    VStack(spacing: 16) {
                        Text("MOA")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                        Text("Meet On App")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.gray)
                            .tracking(0.5)
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)

                    Spacer()

                    // Loading indicator
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color(red: 0.4, green: 0.3, blue: 0.8))
                                .frame(width: 8, height: 8)
                                .opacity(opacity * (Double(index) * 0.3 + 0.4))
                        }
                    }

                    Spacer()
                        .frame(height: 60)
                }
                .padding()
            }
            .onAppear {
                // Animate in
                withAnimation(.easeInOut(duration: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }

                // Transition to login after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}

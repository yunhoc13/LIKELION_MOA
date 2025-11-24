import SwiftUI

@main
struct MOAApp: App {
    @StateObject var appState = AppState()
    @State private var showSplash: Bool = true

    var body: some Scene {
            WindowGroup {
                ZStack {
                    // 1) 메인 컨텐츠: 로그인 여부에 따라 분기
                    if appState.isLoggedIn {
                        if appState.isProfileSetupComplete {
                            HomeView()
                        } else {
                            ProfileSetupView()
                        }
                    } else {
                        AuthenticationView()
                    }

                    // 2) 그 위에 스플래시를 처음에만 오버레이
                    if showSplash {
                        SplashView()
                            .transition(.opacity)
                    }
                }
                .environmentObject(appState)
                .onAppear {
                    // 1.5~2초 정도 후에 스플래시 사라지게 (원하는 시간으로 조정 가능)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            }
        }
    }

//
//  Rootview.swift
//  likelion
//
//  Created by 최윤호 on 11/20/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                // ✅ 로그인 된 상태 → 메인 탭 화면
                HomeView()
            } else {
                // ✅ 로그인 안 된 상태 → 로그인/회원가입 화면
                AuthenticationView()
            }
        }
    }
}


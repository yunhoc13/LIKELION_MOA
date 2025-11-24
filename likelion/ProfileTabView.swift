import SwiftUI

struct ProfileTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Header with user info
            VStack(spacing: 12) {
                // Profile picture placeholder
                Circle()
                    .fill(Color(red: 0.4, green: 0.3, blue: 0.8))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text("👤")
                            .font(.system(size: 40))
                    )

                VStack(spacing: 4) {
                    Text(appState.currentUser?.name ?? "User")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Text(appState.currentUser?.university ?? "Boston University")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)

                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)

                        Text("Email Verified")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color(.systemGray6))

            // Profile sections
            ScrollView {
                VStack(spacing: 0) {
                    // Account Information Section
                    ProfileSection(
                        title: "Account Information",
                        items: [
                            ("Email", appState.currentUser?.email ?? "user@example.com"),
                            ("University", appState.currentUser?.university ?? "Boston University")
                        ]
                    )

                    // Verification Section
                    ProfileSection(
                        title: "Verification",
                        items: [
                            ("Email Status", ".edu Verified"),
                            ("Social Links", "Instagram, LinkedIn")
                        ]
                    )

                    // Settings Section
                    ProfileSection(
                        title: "Settings",
                        items: [
                            ("Notifications", "Enabled"),
                            ("Language", "English")
                        ]
                    )

                    // Safety Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Safety & Community")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(16)

                        VStack(spacing: 12) {
                            ProfileActionButton(
                                icon: "exclamationmark.circle",
                                title: "View Block List",
                                action: {}
                            )

                            ProfileActionButton(
                                icon: "flag.circle",
                                title: "Report History",
                                action: {}
                            )
                        }
                        .padding(16)
                    }

                    // Logout button
                    Button(action: {
                        appState.logout()
                    }) {
                        Text("Logout")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct ProfileSection: View {
    let title: String
    let items: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                ForEach(items, id: \.0) { key, value in
                    HStack {
                        Text(key)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray)

                        Spacer()

                        Text(value)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .border(Color(.systemGray4), width: 1)
        }
    }
}

#Preview {
    ProfileTabView()
        .environmentObject(AppState())
}

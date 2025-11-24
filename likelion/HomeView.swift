import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            VStack {
                // Tab content
                Group {
                    if selectedTab == 0 {
                        HomeTabView()
                    } else if selectedTab == 1 {
                        CategoriesTabView()
                    } else if selectedTab == 2 {
                        CalendarTabView()
                    } else if selectedTab == 3 {
                        ProfileTabView()
                    }
                }
                .environmentObject(appState)

                Spacer()
            }

            VStack {
                Spacer()

                // Bottom Navigation Bar
                HStack(spacing: 0) {
                    // Home Tab
                    TabBarItem(
                        icon: "house.fill",
                        label: "Home",
                        isSelected: selectedTab == 0
                    )
                    .onTapGesture {
                        selectedTab = 0
                    }

                    // Categories Tab
                    TabBarItem(
                        icon: "square.grid.2x2",
                        label: "Categories",
                        isSelected: selectedTab == 1
                    )
                    .onTapGesture {
                        selectedTab = 1
                    }

                    // Calendar Tab
                    TabBarItem(
                        icon: "calendar",
                        label: "Calendar",
                        isSelected: selectedTab == 2
                    )
                    .onTapGesture {
                        selectedTab = 2
                    }

                    // Profile Tab
                    TabBarItem(
                        icon: "person.fill",
                        label: "Profile",
                        isSelected: selectedTab == 3
                    )
                    .onTapGesture {
                        selectedTab = 3
                    }
                }
                .frame(height: 70)
                .background(Color.white)
                .border(Color(.systemGray5), width: 1)
            }

            // Floating + Button
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 90)
                }
            }
        }
    }
}

// Tab Bar Item Component
struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.system(size: 10, weight: .regular))
        }
        .foregroundColor(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8) : .gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}

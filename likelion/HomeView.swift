import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0
    @State private var showCreateActivity: Bool = false

    var body: some View {
        NavigationStack {
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
                        MyEventsTabView()
                    } else if selectedTab == 4 {
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

                    // My Events Tab
                    TabBarItem(
                        icon: "bookmark.fill",
                        label: "My Events",
                        isSelected: selectedTab == 3
                    )
                    .onTapGesture {
                        selectedTab = 3
                    }

                    // Profile Tab
                    TabBarItem(
                        icon: "person.fill",
                        label: "Profile",
                        isSelected: selectedTab == 4
                    )
                    .onTapGesture {
                        selectedTab = 4
                    }
                }
                .frame(height: 70)
                .background(Color.white)
                .border(Color(.systemGray5), width: 1)
            }

            // Floating + Button (not shown on My Events or Profile tabs)
            if selectedTab != 3 && selectedTab != 4 {
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Button(action: { showCreateActivity = true }) {
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
            .navigationDestination(isPresented: $showCreateActivity) {
                CreateActivityWrapperView(isPresented: $showCreateActivity)
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

// Create Activity Wrapper - Shows category selection first
struct CreateActivityWrapperView: View {
    @Binding var isPresented: Bool
    @State private var selectedCategory: Activity.ActivityCategory?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            if let category = selectedCategory {
                // Show form with selected category
                CreateActivityView(category: category, isPresented: $isPresented)
            } else {
                // Show category selection
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                        }

                        Spacer()

                        Text("Create New Activity")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)

                        Spacer()

                        Color.clear
                            .frame(width: 20)
                    }
                    .padding(16)
                    .background(Color.white)

                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Select a Category")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)

                            VStack(spacing: 12) {
                                // Study
                                Button(action: { selectedCategory = .study }) {
                                    HStack(spacing: 16) {
                                        Text(Activity.ActivityCategory.study.emoji)
                                            .font(.system(size: 32))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Study")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)

                                            Text("Study groups and exam prep")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }

                                // Meal Buddy
                                Button(action: { selectedCategory = .mealBuddy }) {
                                    HStack(spacing: 16) {
                                        Text(Activity.ActivityCategory.mealBuddy.emoji)
                                            .font(.system(size: 32))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Meal Buddy")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)

                                            Text("Find people to eat with")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }

                                // Sports
                                Button(action: { selectedCategory = .sports }) {
                                    HStack(spacing: 16) {
                                        Text(Activity.ActivityCategory.sports.emoji)
                                            .font(.system(size: 32))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Sports")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)

                                            Text("Form sports teams and groups")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }

                                // Others
                                Button(action: { selectedCategory = .others }) {
                                    HStack(spacing: 16) {
                                        Text(Activity.ActivityCategory.others.emoji)
                                            .font(.system(size: 32))

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Others")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)

                                            Text("Coffee chats and socializing")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}

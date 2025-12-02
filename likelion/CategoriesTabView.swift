import SwiftUI

struct CategoriesTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var activities: [Activity] = []
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header
                VStack(alignment: .leading) {
                    Text("Categories")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Text("Choose a category to find activities")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)

                // Category cards
                VStack(spacing: 12) {
                    NavigationLink(destination: CategoryActivityListView(category: .study)) {
                        CategoryCardLarge(
                            icon: "📚",
                            title: "Study",
                            description: "Find study groups and exam prep"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .mealBuddy)) {
                        CategoryCardLarge(
                            icon: "🍜",
                            title: "Meal Buddy",
                            description: "Find people to eat with"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .sports)) {
                        CategoryCardLarge(
                            icon: "⚽",
                            title: "Sports",
                            description: "Form sports teams and groups"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .others)) {
                        CategoryCardLarge(
                            icon: "☕",
                            title: "Others",
                            description: "Coffee chats and socializing"
                        )
                    }
                }
                .padding(16)

                Spacer()
            }
        }
        .onAppear {
            fetchActivities()
        }
    }

    private func fetchActivities() {
        isLoading = true
        Task {
            do {
                let fetchedActivityData = try await APIService.shared.fetchActivities()
                let convertedActivities = fetchedActivityData.map { data -> Activity in
                    Activity(
                        id: data.id,
                        title: data.title,
                        category: Activity.ActivityCategory(rawValue: data.category) ?? .others,
                        description: data.description,
                        hostUserId: data.hostUserId,
                        hostName: data.hostName,
                        locationName: data.locationName,
                        locationLat: data.locationLat,
                        locationLng: data.locationLng,
                        startDateTime: data.startDateTime,
                        endDateTime: data.endDateTime,
                        isInstant: data.isInstant,
                        maxParticipants: data.maxParticipants,
                        currentParticipants: data.currentParticipants,
                        status: Activity.ActivityStatus(rawValue: data.status) ?? .open,
                        participants: data.participants,
                        createdAt: data.createdAt,
                        updatedAt: data.updatedAt
                    )
                }

                activities = convertedActivities
                isLoading = false
            } catch {
                // Clear activities if API fails - no fallback to samples
                activities = []
                isLoading = false
            }
        }
    }
}

struct CategoryCardLarge: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)

                    Text(description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    NavigationStack {
        CategoriesTabView()
            .environmentObject(AppState())
    }
}

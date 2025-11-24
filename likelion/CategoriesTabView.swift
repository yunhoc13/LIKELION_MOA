import SwiftUI

struct CategoriesTabView: View {
    @EnvironmentObject var appState: AppState

    let activities: [Activity] = Activity.samples

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
                    NavigationLink(destination: CategoryActivityListView(category: .study, activities: activities)) {
                        CategoryCardLarge(
                            icon: "📚",
                            title: "Study",
                            description: "Find study groups and exam prep"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .mealBuddy, activities: activities)) {
                        CategoryCardLarge(
                            icon: "🍜",
                            title: "Meal Buddy",
                            description: "Find people to eat with"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .sports, activities: activities)) {
                        CategoryCardLarge(
                            icon: "⚽",
                            title: "Sports",
                            description: "Form sports teams and groups"
                        )
                    }

                    NavigationLink(destination: CategoryActivityListView(category: .others, activities: activities)) {
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
    CategoriesTabView()
        .environmentObject(AppState())
}

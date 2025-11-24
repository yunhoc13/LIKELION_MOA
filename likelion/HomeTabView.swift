import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory = 0
    @State private var navigateToCategory: Activity.ActivityCategory?
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail: Bool = false

    let activities: [Activity] = Activity.samples

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
            // Header with MOA logo
            VStack(spacing: 16) {
                Text("MOA")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                Text("Today on MOA")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Centered Category chips
                HStack(spacing: 8) {
                    Spacer()

                    NavigationLink(destination: CategoryDetailView(category: .study, activities: activities)) {
                        CategoryChip(label: "스터디", isSelected: selectedCategory == 0)
                    }

                    NavigationLink(destination: CategoryDetailView(category: .mealBuddy, activities: activities)) {
                        CategoryChip(label: "밥친구", isSelected: selectedCategory == 1)
                    }

                    NavigationLink(destination: CategoryDetailView(category: .sports, activities: activities)) {
                        CategoryChip(label: "스포츠", isSelected: selectedCategory == 2)
                    }

                    NavigationLink(destination: CategoryDetailView(category: .others, activities: activities)) {
                        CategoryChip(label: "기타", isSelected: selectedCategory == 3)
                    }

                    Spacer()
                }
                .frame(height: 32)
            }
            .padding(16)
            .background(Color.white)

            // Trending Now Section
            ScrollView {
                VStack(spacing: 16) {
                    Text("Trending Now")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    // Trending cards in 2x2 grid
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            NavigationLink(destination: ActivityDetailView(activity: activities[0])) {
                                TrendingCard(
                                    icon: activities[0].category.emoji,
                                    title: activities[0].title,
                                    description: activities[0].description
                                )
                            }

                            NavigationLink(destination: ActivityDetailView(activity: activities[1])) {
                                TrendingCard(
                                    icon: activities[1].category.emoji,
                                    title: activities[1].title,
                                    description: activities[1].description,
                                    isHighlighted: true
                                )
                            }
                        }

                        HStack(spacing: 12) {
                            NavigationLink(destination: ActivityDetailView(activity: activities[2])) {
                                TrendingCard(
                                    icon: activities[2].category.emoji,
                                    title: activities[2].title,
                                    description: activities[2].description
                                )
                            }

                            if activities.count > 3 {
                                NavigationLink(destination: ActivityDetailView(activity: activities[3])) {
                                    TrendingCard(
                                        icon: activities[3].category.emoji,
                                        title: activities[3].title,
                                        description: activities[3].description
                                    )
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            }
            .background(Color(.systemGray6))
        }
    }
}

struct CategoryChip: View {
    let label: String
    let isSelected: Bool

    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color.white)
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(16)
            .border(isSelected ? Color.clear : Color(.systemGray4), width: 1)
    }
}

struct TrendingCard: View {
    let icon: String
    let title: String
    let description: String
    var isHighlighted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon/Image area
            ZStack {
                if isHighlighted {
                    Color(red: 0.3, green: 0.5, blue: 0.9)
                } else {
                    Color(red: 0.3, green: 0.3, blue: 0.3)
                }

                Text(icon)
                    .font(.system(size: 32))
            }
            .frame(height: 100)
            .cornerRadius(8)

            // Title
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(1)

            // Description
            Text(description)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.gray)
                .lineLimit(2)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .border(isHighlighted ? Color(red: 0.3, green: 0.5, blue: 0.9) : Color.clear, width: 2)
    }
}

struct CategoryDetailView: View {
    let category: Activity.ActivityCategory
    let activities: [Activity]
    @Environment(\.dismiss) var dismiss

    var filteredActivities: [Activity] {
        activities.filter { $0.category == category }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }

                Spacer()

                Text(category.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                Color.clear
                    .frame(width: 20)
            }
            .padding(16)
            .background(Color.white)

            ScrollView {
                VStack(spacing: 12) {
                    if filteredActivities.isEmpty {
                        Text("No activities available")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(32)
                    } else {
                        ForEach(filteredActivities) { activity in
                            NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                CategoryActivityRow(activity: activity)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
    }
}

struct CategoryActivityRow: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(activity.category.emoji)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)

                    Text(activity.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(activity.currentParticipants) / \(activity.maxParticipants)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.black)

                    if activity.isFull {
                        Text("Full")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.red)
                    }
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)

                Text(activity.locationName)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "clock")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)

                Text(timeString(activity.startDateTime))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeTabView()
        .environmentObject(AppState())
}

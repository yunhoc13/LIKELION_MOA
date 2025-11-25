import SwiftUI

struct CategoryActivityListView: View {
    let category: Activity.ActivityCategory
    let activities: [Activity]
    @Environment(\.dismiss) var dismiss
    @State private var showCreateActivity: Bool = false
    @State private var selectedDate: Date?
    @State private var filterByDate: Bool = false
    @State private var sortByDistance: Bool = false
    @State private var filterBySchool: Bool = false

    var filteredActivities: [Activity] {
        var filtered = activities.filter { $0.category == category }

        if filterByDate, let date = selectedDate {
            filtered = filtered.filter { activity in
                Calendar.current.isDate(activity.startDateTime, inSameDayAs: date)
            }
        }

        return filtered
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .font(.system(size: 16))
                }

                Text(category.rawValue)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            ScrollView {
                VStack(spacing: 6) {
                    // Filter Options
                    VStack(spacing: 8) {
                        Text("Filters")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Date Filter
                        VStack(spacing: 6) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 11))

                                Text("Filter by Date")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.black)

                                Spacer()

                                Toggle("", isOn: $filterByDate)
                                    .scaleEffect(0.75)
                            }

                            if filterByDate {
                                DatePicker(
                                    "Select Date",
                                    selection: Binding(
                                        get: { selectedDate ?? Date() },
                                        set: { selectedDate = $0 }
                                    ),
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        // Distance Filter
                        HStack {
                            Image(systemName: "location.circle")
                                .foregroundColor(.gray)
                                .font(.system(size: 11))

                            Text("Near Me")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.black)

                            Spacer()

                            Toggle("", isOn: $sortByDistance)
                                .scaleEffect(0.75)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        // School Filter
                        HStack {
                            Image(systemName: "building.2")
                                .foregroundColor(.gray)
                                .font(.system(size: 11))

                            Text("My School Only")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.black)

                            Spacer()

                            Toggle("", isOn: $filterBySchool)
                                .scaleEffect(0.75)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)

                    // Activities List
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Activities (\(filteredActivities.count))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)

                        if filteredActivities.isEmpty {
                            Text("No activities found")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(8)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(filteredActivities) { activity in
                                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                        ActivityListItem(activity: activity)
                                    }
                                }
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)

                    // Create Activity Button
                    Button(action: { showCreateActivity = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 14))

                            Text("Create \(category.rawValue) Activity")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .cornerRadius(8)
                    }
                    .padding(10)
                }
                .padding(.horizontal, 10)
                .padding(.top, 0)
                .padding(.bottom, 10)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showCreateActivity) {
            CreateActivityView(category: category, isPresented: $showCreateActivity)
        }
    }
}

struct ActivityListItem: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(activity.category.emoji)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(activity.description)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(activity.currentParticipants)/\(activity.maxParticipants)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.black)

                    if activity.isFull {
                        Text("Full")
                            .font(.system(size: 9, weight: .regular))
                            .foregroundColor(.red)
                    } else {
                        Text("\(activity.spotsAvailable) spots")
                            .font(.system(size: 9, weight: .regular))
                            .foregroundColor(.green)
                    }
                }
            }

            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)

                Text(timeString(activity.startDateTime))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)

                Spacer()

                Image(systemName: "location.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)

                Text(activity.locationName)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        CategoryActivityListView(
            category: .study,
            activities: Activity.samples
        )
    }
}

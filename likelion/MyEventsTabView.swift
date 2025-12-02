import SwiftUI

struct MyEventsTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var activities: [Activity] = []
    @State private var isLoading: Bool = false

    var createdEvents: [Activity] {
        guard let user = appState.currentUser else { return [] }
        return activities.filter { activity in
            activity.hostUserId == user.id
        }
    }

    var joinedEvents: [Activity] {
        guard let user = appState.currentUser else { return [] }
        return activities.filter { activity in
            activity.hostUserId != user.id && activity.participants.contains(user.id)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Events")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Text("Events you created or joined")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.white)

                // Events List
                ScrollView {
                    VStack(spacing: 20) {
                        if createdEvents.isEmpty && joinedEvents.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)

                                Text("No events yet")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)

                                Text("Create or join an event to see it here")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(32)
                        } else {
                            // Created Events Section
                            if !createdEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                                        Text("Created Events")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)

                                        Spacer()

                                        Text("\(createdEvents.count)")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                    VStack(spacing: 8) {
                                        ForEach(createdEvents) { activity in
                                            NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                                MyEventCard(activity: activity, user: appState.currentUser)
                                            }
                                        }
                                    }
                                }
                            }

                            // Joined Events Section
                            if !joinedEvents.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.green)

                                        Text("Joined Events")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)

                                        Spacer()

                                        Text("\(joinedEvents.count)")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                    VStack(spacing: 8) {
                                        ForEach(joinedEvents) { activity in
                                            NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                                MyEventCard(activity: activity, user: appState.currentUser)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color(.systemGray6))
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
                activities = []
                isLoading = false
            }
        }
    }
}

struct MyEventCard: View {
    let activity: Activity
    let user: User?

    var eventType: String {
        guard let user = user else { return "" }
        if activity.hostUserId == user.id {
            return "Hosting"
        } else {
            return "Joined"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Category emoji
                Text(activity.category.emoji)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)

                    HStack(spacing: 8) {
                        // Event type badge
                        Text(eventType)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(activity.hostUserId == user?.id ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color.green)
                            .cornerRadius(4)

                        Text(activity.category.rawValue)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(activity.currentParticipants)/\(activity.maxParticipants)")
                        .font(.system(size: 11, weight: .semibold))
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

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)

                Text(dateString(activity.startDateTime))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)

                Spacer()

                Image(systemName: "location.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)

                Text(activity.locationName)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    MyEventsTabView()
        .environmentObject(AppState())
}

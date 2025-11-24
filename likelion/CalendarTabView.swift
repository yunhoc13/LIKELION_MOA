import SwiftUI

struct CalendarTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date?
    @State private var showMyActivitiesOnly: Bool = false
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail: Bool = false

    // Sample activities - in real app, these would come from backend
    let activities: [Activity] = Activity.samples

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Calendar")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                Text("View your activities by date")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)

            ScrollView {
                VStack(spacing: 16) {
                    // Monthly Calendar
                    CalendarGridView(
                        currentDate: $currentDate,
                        selectedDate: $selectedDate,
                        activities: activities
                    )

                    // Toggle for My Activities / All Activities
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button(action: { showMyActivitiesOnly = false }) {
                                Text("All nearby activities")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(showMyActivitiesOnly ? .gray : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(showMyActivitiesOnly ? Color(.systemGray5) : Color(red: 0.4, green: 0.3, blue: 0.8))
                                    .cornerRadius(8)
                            }

                            Button(action: { showMyActivitiesOnly = true }) {
                                Text("My activities only")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(!showMyActivitiesOnly ? .gray : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(!showMyActivitiesOnly ? Color(.systemGray5) : Color(red: 0.4, green: 0.3, blue: 0.8))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)

                    // Activities for Selected Date
                    if let date = selectedDate {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(dateHeaderString(date))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)

                            let activitiesOnDate = getActivitiesForDate(date)
                            if activitiesOnDate.isEmpty {
                                Text("No activities scheduled")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                                    .padding(16)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(activitiesOnDate) { activity in
                                        ActivityDateItem(activity: activity)
                                            .onTapGesture {
                                                selectedActivity = activity
                                                showActivityDetail = true
                                            }
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }

                    Spacer()
                        .frame(height: 20)
                }
            }
        }
        .background(Color(.systemGray6))
        .navigationDestination(isPresented: $showActivityDetail) {
            if let activity = selectedActivity {
                ActivityDetailView(activity: activity)
            }
        }
    }

    private func getActivitiesForDate(_ date: Date) -> [Activity] {
        let calendar = Calendar.current
        return activities.filter { activity in
            calendar.isDate(activity.startDateTime, inSameDayAs: date)
        }
    }

    private func dateHeaderString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarGridView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date?
    let activities: [Activity]

    var body: some View {
        VStack(spacing: 12) {
            // Month Navigation
            HStack {
                Button(action: { currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }

                Spacer()

                Text(monthYearString(currentDate))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                Button(action: { currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Day labels
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)

            // Calendar Grid
            let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
            let range = Calendar.current.range(of: .day, in: .month, for: currentDate)!
            let numDays = range.count
            let startingWeekday = Calendar.current.component(.weekday, from: firstDay) - 1

            VStack(spacing: 8) {
                ForEach(0..<((startingWeekday + numDays + 6) / 7), id: \.self) { week in
                    HStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { day in
                            let dayIndex = week * 7 + day - startingWeekday
                            CalendarDayCell(
                                day: dayIndex > 0 && dayIndex <= numDays ? dayIndex : 0,
                                isSelected: selectedDate.map { Calendar.current.isDate($0, inSameDayAs: Calendar.current.date(byAdding: .day, value: dayIndex - 1, to: firstDay)!) } ?? false,
                                hasActivity: dayIndex > 0 && dayIndex <= numDays && hasActivityOnDay(dayIndex),
                                action: {
                                    if dayIndex > 0 && dayIndex <= numDays {
                                        selectedDate = Calendar.current.date(byAdding: .day, value: dayIndex - 1, to: firstDay)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(16)
    }

    private func hasActivityOnDay(_ day: Int) -> Bool {
        let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        let targetDate = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDay)!
        return activities.contains { Calendar.current.isDate($0.startDateTime, inSameDayAs: targetDate) }
    }

    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarDayCell: View {
    let day: Int
    let isSelected: Bool
    let hasActivity: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                if day > 0 {
                    VStack {
                        Text("\(day)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(isSelected ? .white : .black)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color(.systemGray6))
                    .cornerRadius(6)

                    if hasActivity {
                        Circle()
                            .fill(Color(red: 0.97, green: 0.5, blue: 0.25))
                            .frame(width: 6, height: 6)
                            .padding(4)
                    }
                }
            }
            .frame(height: 40)
        }
    }
}

struct ActivityDateItem: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(activity.category.emoji)
                    .font(.system(size: 14))

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        Text(timeString(activity.startDateTime))
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)

                        Text(activity.category.rawValue)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)

                Text(activity.locationName)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct ActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                }
                Spacer()
                Text("Activity Details")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Color.clear
                    .frame(width: 20)
            }
            .padding(16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Activity Header
                    HStack(spacing: 12) {
                        Text(activity.category.emoji)
                            .font(.system(size: 32))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)

                            Text(activity.category.rawValue)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Details
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(label: "Time", value: dateTimeString(activity.startDateTime))
                        DetailRow(label: "Location", value: activity.locationName)
                        DetailRow(label: "Description", value: activity.description)
                        DetailRow(label: "Host", value: activity.hostName)
                        DetailRow(label: "Participants", value: "\(activity.currentParticipants) / \(activity.maxParticipants)")
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)

                    // Join Button
                    Button(action: {}) {
                        Text(activity.isFull ? "Activity Full" : "Join Activity")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(activity.isFull ? Color.gray : Color(red: 0.4, green: 0.3, blue: 0.8))
                            .cornerRadius(8)
                    }
                    .disabled(activity.isFull)
                    .padding(16)
                }
            }
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
    }

    private func dateTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)

            Spacer()
        }
    }
}

#Preview {
    CalendarTabView()
        .environmentObject(AppState())
}

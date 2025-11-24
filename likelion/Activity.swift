import Foundation

struct Activity: Identifiable {
    let id: String
    let title: String
    let category: ActivityCategory
    let description: String
    let hostUserId: String
    let hostName: String
    let locationName: String
    let locationLat: Double
    let locationLng: Double
    let startDateTime: Date
    let endDateTime: Date?
    let isInstant: Bool
    let maxParticipants: Int
    let currentParticipants: Int
    let status: ActivityStatus
    let participants: [String]
    let createdAt: Date
    let updatedAt: Date

    enum ActivityCategory: String, CaseIterable {
        case study = "Study"
        case mealBuddy = "Meal Buddy"
        case sports = "Sports"
        case others = "Others"

        var emoji: String {
            switch self {
            case .study:
                return "📚"
            case .mealBuddy:
                return "🍜"
            case .sports:
                return "⚽"
            case .others:
                return "☕"
            }
        }

        var color: (red: Double, green: Double, blue: Double) {
            switch self {
            case .study:
                return (0.3, 0.5, 0.9)
            case .mealBuddy:
                return (0.97, 0.65, 0.75)
            case .sports:
                return (0.97, 0.5, 0.25)
            case .others:
                return (0.65, 0.85, 0.8)
            }
        }
    }

    enum ActivityStatus: String {
        case open = "open"
        case full = "full"
        case finished = "finished"
        case cancelled = "cancelled"
    }

    var isFull: Bool {
        currentParticipants >= maxParticipants
    }

    var spotsAvailable: Int {
        maxParticipants - currentParticipants
    }
}

// Sample data for testing
extension Activity {
    static let samples: [Activity] = [
        // Study Activities
        Activity(
            id: "1",
            title: "CS330 Algorithms Study",
            category: .study,
            description: "Midterm preparation for data structures",
            hostUserId: "user1",
            hostName: "John Doe",
            locationName: "BU Library - 3rd Floor",
            locationLat: 42.3505,
            locationLng: -71.1054,
            startDateTime: Date().addingTimeInterval(3600),
            endDateTime: Date().addingTimeInterval(7200),
            isInstant: false,
            maxParticipants: 6,
            currentParticipants: 3,
            status: .open,
            participants: ["user1", "user2", "user3"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "10",
            title: "GRE Quant Practice",
            category: .study,
            description: "Quantitative reasoning prep",
            hostUserId: "user5",
            hostName: "Sarah Kim",
            locationName: "Northeastern Library",
            locationLat: 42.3390,
            locationLng: -71.0890,
            startDateTime: Date().addingTimeInterval(7200),
            endDateTime: Date().addingTimeInterval(10800),
            isInstant: false,
            maxParticipants: 5,
            currentParticipants: 4,
            status: .open,
            participants: ["user5", "user6", "user7", "user8"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "11",
            title: "TOEFL Speaking Group",
            category: .study,
            description: "English speaking practice for TOEFL",
            hostUserId: "user9",
            hostName: "Emily Park",
            locationName: "MIT Stata Center",
            locationLat: 42.3600,
            locationLng: -71.0927,
            startDateTime: Date().addingTimeInterval(10800),
            endDateTime: Date().addingTimeInterval(14400),
            isInstant: false,
            maxParticipants: 8,
            currentParticipants: 6,
            status: .open,
            participants: ["user9", "user10", "user1", "user2", "user3", "user4"],
            createdAt: Date(),
            updatedAt: Date()
        ),

        // Meal Buddy Activities
        Activity(
            id: "2",
            title: "Korean Lunch",
            category: .mealBuddy,
            description: "Let's eat Korean BBQ together",
            hostUserId: "user2",
            hostName: "Jane Smith",
            locationName: "Allston (Korea Town)",
            locationLat: 42.3506,
            locationLng: -71.1064,
            startDateTime: Date().addingTimeInterval(1800),
            endDateTime: Date().addingTimeInterval(5400),
            isInstant: false,
            maxParticipants: 4,
            currentParticipants: 2,
            status: .open,
            participants: ["user2", "user4"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "12",
            title: "Dinner at Harvard Square",
            category: .mealBuddy,
            description: "Korean restaurant dinner",
            hostUserId: "user11",
            hostName: "David Lee",
            locationName: "Harvard Square",
            locationLat: 42.3735,
            locationLng: -71.1207,
            startDateTime: Date().addingTimeInterval(54000),
            endDateTime: Date().addingTimeInterval(57600),
            isInstant: false,
            maxParticipants: 5,
            currentParticipants: 3,
            status: .open,
            participants: ["user11", "user12", "user13"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "13",
            title: "Lunch Near MIT",
            category: .mealBuddy,
            description: "Casual lunch, trying new place",
            hostUserId: "user14",
            hostName: "Alex Wong",
            locationName: "Kendall Square",
            locationLat: 42.3627,
            locationLng: -71.0894,
            startDateTime: Date().addingTimeInterval(43200),
            endDateTime: Date().addingTimeInterval(46800),
            isInstant: false,
            maxParticipants: 6,
            currentParticipants: 4,
            status: .open,
            participants: ["user14", "user15", "user16", "user17"],
            createdAt: Date(),
            updatedAt: Date()
        ),

        // Sports Activities
        Activity(
            id: "3",
            title: "Basketball Game",
            category: .sports,
            description: "5v5 casual basketball",
            hostUserId: "user3",
            hostName: "Mike Johnson",
            locationName: "BU FitRec",
            locationLat: 42.3510,
            locationLng: -71.1070,
            startDateTime: Date().addingTimeInterval(21600),
            endDateTime: Date().addingTimeInterval(25200),
            isInstant: false,
            maxParticipants: 10,
            currentParticipants: 8,
            status: .full,
            participants: ["user3", "user1", "user2", "user4", "user5", "user6", "user7", "user8"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "14",
            title: "Jogging at Charles River",
            category: .sports,
            description: "Morning jog along the river",
            hostUserId: "user18",
            hostName: "Lisa Chen",
            locationName: "Charles River Esplanade",
            locationLat: 42.3598,
            locationLng: -71.1093,
            startDateTime: Date().addingTimeInterval(28800),
            endDateTime: Date().addingTimeInterval(32400),
            isInstant: false,
            maxParticipants: 12,
            currentParticipants: 5,
            status: .open,
            participants: ["user18", "user19", "user20", "user21", "user22"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "15",
            title: "Futsal Game at MIT",
            category: .sports,
            description: "Indoor soccer, beginner friendly",
            hostUserId: "user23",
            hostName: "Marcus Brown",
            locationName: "MIT Gym",
            locationLat: 42.3611,
            locationLng: -71.0896,
            startDateTime: Date().addingTimeInterval(57600),
            endDateTime: Date().addingTimeInterval(61200),
            isInstant: false,
            maxParticipants: 8,
            currentParticipants: 6,
            status: .open,
            participants: ["user23", "user24", "user25", "user26", "user27", "user28"],
            createdAt: Date(),
            updatedAt: Date()
        ),

        // Others/Community Activities
        Activity(
            id: "4",
            title: "Coffee Chat in Korean",
            category: .others,
            description: "Casual conversation in Korean",
            hostUserId: "user29",
            hostName: "Sophie Park",
            locationName: "Café near BU",
            locationLat: 42.3485,
            locationLng: -71.1035,
            startDateTime: Date().addingTimeInterval(14400),
            endDateTime: Date().addingTimeInterval(18000),
            isInstant: false,
            maxParticipants: 6,
            currentParticipants: 3,
            status: .open,
            participants: ["user29", "user30", "user31"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "16",
            title: "Language Exchange - Korean & English",
            category: .others,
            description: "Practice both Korean and English",
            hostUserId: "user32",
            hostName: "James Wilson",
            locationName: "Harvard Square Café",
            locationLat: 42.3735,
            locationLng: -71.1207,
            startDateTime: Date().addingTimeInterval(50400),
            endDateTime: Date().addingTimeInterval(54000),
            isInstant: false,
            maxParticipants: 8,
            currentParticipants: 5,
            status: .open,
            participants: ["user32", "user33", "user34", "user35", "user36"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "17",
            title: "Board Game Night",
            category: .others,
            description: "Play board games, free snacks!",
            hostUserId: "user37",
            hostName: "Rachel Kim",
            locationName: "NEU Student Center",
            locationLat: 42.3390,
            locationLng: -71.0890,
            startDateTime: Date().addingTimeInterval(64800),
            endDateTime: Date().addingTimeInterval(72000),
            isInstant: false,
            maxParticipants: 12,
            currentParticipants: 7,
            status: .open,
            participants: ["user37", "user38", "user39", "user40", "user41", "user42", "user43"],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Activity(
            id: "18",
            title: "Walk Along Charles River",
            category: .others,
            description: "Leisurely walk and chat",
            hostUserId: "user44",
            hostName: "Tom Anderson",
            locationName: "Charles River Park",
            locationLat: 42.3598,
            locationLng: -71.1093,
            startDateTime: Date().addingTimeInterval(36000),
            endDateTime: Date().addingTimeInterval(39600),
            isInstant: false,
            maxParticipants: 10,
            currentParticipants: 4,
            status: .open,
            participants: ["user44", "user45", "user46", "user47"],
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
}

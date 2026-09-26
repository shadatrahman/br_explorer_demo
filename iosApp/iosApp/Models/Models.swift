import SwiftUI
import CoreLocation

struct Station: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
}

struct FareClass: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let abbreviation: String
    let fare: Int
}

struct TrainSchedule: Identifiable {
    let id = UUID()
    let number: String
    let name: String
    let origin: String
    let destination: String
    let departure: String
    let arrival: String
    let status: SignalStatus
    let fares: [FareClass]

    // Live position detail — legacy "Location of Train" fields.
    let currentLocation: String
    let nextStop: String
    let nextStopETA: String
    let coachPosition: String
    let totalCoaches: Int
    let currentSpeedKmh: Int
    let delay: String
    let lastUpdate: String
    let routeCoordinates: [CLLocationCoordinate2D]
    let liveCoordinate: CLLocationCoordinate2D
}

extension TrainSchedule: Equatable, Hashable {
    static func == (lhs: TrainSchedule, rhs: TrainSchedule) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum TripOutcome {
    case completed, upcoming, cancelled

    var label: String {
        switch self {
        case .completed: return "Completed"
        case .upcoming: return "Upcoming"
        case .cancelled: return "Cancelled"
        }
    }

    var color: Color {
        switch self {
        case .completed: return BRColor.signalGreen
        case .upcoming: return BRColor.signalAmber
        case .cancelled: return BRColor.textSecondary
        }
    }
}

struct HistoryEntry: Identifiable {
    let id = UUID()
    let train: TrainSchedule
    let tripDate: String
    let fareClass: String
    let outcome: TripOutcome
}

enum MockData {
    static let stations: [Station] = [
        Station(name: "Dhaka", code: "DHK"),
        Station(name: "Chuadanga", code: "CUA"),
        Station(name: "Khulna", code: "KHA"),
        Station(name: "Jashore", code: "JSR"),
        Station(name: "Rajshahi", code: "RAJ"),
        Station(name: "Sylhet", code: "SYL"),
        Station(name: "Chattogram", code: "CTG"),
        Station(name: "Mymensingh", code: "MYM"),
        Station(name: "Rangpur", code: "RGP"),
        Station(name: "Barishal", code: "BRS"),
        Station(name: "Comilla", code: "CML"),
        Station(name: "Noakhali", code: "NKL"),
        Station(name: "Kishoreganj", code: "KSG"),
        Station(name: "Mobarakganj", code: "MBG"),
    ]

    static let sundarban = TrainSchedule(
        number: "725",
        name: "Sundarban Express",
        origin: "Khulna",
        destination: "Dhaka",
        departure: "21:45",
        arrival: "05:14",
        status: .delayed,
        fares: [
            FareClass(name: "Shovon", abbreviation: "SH", fare: 375),
            FareClass(name: "Snigdha", abbreviation: "SNG", fare: 719),
            FareClass(name: "AC-B", abbreviation: "AC-B", fare: 862),
        ],
        currentLocation: "Jashore Jn",
        nextStop: "Mobarakganj",
        nextStopETA: "23:28",
        coachPosition: "Ka at last",
        totalCoaches: 12,
        currentSpeedKmh: 13,
        delay: "00:04",
        lastUpdate: "22:57 · 26 Sep",
        routeCoordinates: [
            CLLocationCoordinate2D(latitude: 22.8456, longitude: 89.5403), // Khulna
            CLLocationCoordinate2D(latitude: 23.1667, longitude: 89.2167), // Jashore
            CLLocationCoordinate2D(latitude: 23.2794, longitude: 89.1128), // Mobarakganj
            CLLocationCoordinate2D(latitude: 23.8103, longitude: 90.4125), // Dhaka
        ],
        liveCoordinate: CLLocationCoordinate2D(latitude: 23.1667, longitude: 89.2167)
    )

    static let searchResults: [TrainSchedule] = [
        sundarban,
        TrainSchedule(
            number: "763",
            name: "Chitra Express",
            origin: "Khulna",
            destination: "Dhaka",
            departure: "07:00",
            arrival: "13:40",
            status: .onTime,
            fares: [
                FareClass(name: "Shovon", abbreviation: "SH", fare: 375),
                FareClass(name: "Snigdha", abbreviation: "SNG", fare: 719),
            ],
            currentLocation: "Not departed",
            nextStop: "Jashore",
            nextStopETA: "08:12",
            coachPosition: "—",
            totalCoaches: 10,
            currentSpeedKmh: 0,
            delay: "00:00",
            lastUpdate: "—",
            routeCoordinates: [],
            liveCoordinate: CLLocationCoordinate2D(latitude: 22.8456, longitude: 89.5403)
        ),
        TrainSchedule(
            number: "747",
            name: "Simanta Express",
            origin: "Khulna",
            destination: "Dhaka",
            departure: "20:00",
            arrival: "04:10",
            status: .alert,
            fares: [
                FareClass(name: "Shovon", abbreviation: "SH", fare: 350),
                FareClass(name: "AC-B", abbreviation: "AC-B", fare: 840),
            ],
            currentLocation: "Signal hold, Kotchandpur",
            nextStop: "Jashore",
            nextStopETA: "21:50",
            coachPosition: "Ga at front",
            totalCoaches: 11,
            currentSpeedKmh: 0,
            delay: "00:22",
            lastUpdate: "21:30 · 26 Sep",
            routeCoordinates: [],
            liveCoordinate: CLLocationCoordinate2D(latitude: 23.0167, longitude: 89.2833)
        ),
    ]

    static let history: [HistoryEntry] = [
        HistoryEntry(train: sundarban, tripDate: "26 Sep, 2026", fareClass: "Snigdha", outcome: .upcoming),
        HistoryEntry(train: searchResults[1], tripDate: "18 Sep, 2026", fareClass: "Shovon", outcome: .completed),
        HistoryEntry(train: searchResults[2], tripDate: "02 Sep, 2026", fareClass: "AC-B", outcome: .cancelled),
        HistoryEntry(train: searchResults[1], tripDate: "14 Aug, 2026", fareClass: "Snigdha", outcome: .completed),
    ]
}

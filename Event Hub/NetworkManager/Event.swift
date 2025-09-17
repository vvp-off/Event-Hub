//
//  Event.swift
//  Event Hub
//
//  Created by Сергей on 11.09.2025.
//

import Foundation

struct EventsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Event]
}

struct Event: Codable {
    let id: Int
    var dates: [EventDate]
    let title: String
    let slug: String
    let place: Place?
    let images: [EventImage]
    let favoritesCount: Int
    let bodyText: String?
    let siteUrl: String?
    let location: Location?
    let participants: [Participant]?
    let isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, dates, title, slug, place, images, location, participants, isFavorite
        case favoritesCount = "favorites_count"
        case bodyText = "body_text"
        case siteUrl = "site_url"
    }
}

struct EventDate: Codable {
    let start: TimeInterval
    let end: TimeInterval
}

struct Place: Codable {
    let id: Int?
    let title: String?
    let address: String?
}

struct EventImage: Codable {
    let image: String
}

struct Location: Codable {
    let slug: String?
    let name: String?
}

struct Participant: Codable {
    let role: ParticipantRole
    let agent: Agent
}

struct ParticipantRole: Codable {
    let slug: String
}

struct Agent: Codable {
    let id: Int?
    let title: String?
    let slug: String?
    let agentType: String?
    let images: [EventImage]?
    let siteUrl: String?
    let isStub: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, slug
        case agentType = "agent_type"
        case images
        case siteUrl = "site_url"
        case isStub = "is_stub"
    }
}

extension EventDate {
    /// Форматирует дату начала события в строку вида "Wed, Apr 28 • 5:30 PM"
    func formattedStartDate() -> String {
        let date = Date(timeIntervalSince1970: start)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E, MMM d • h:mm a"
        
        return formatter.string(from: date)
    }
}

extension Event {
    /// Форматирует локацию события в строку вида "Lot 13 • Oakland, CA"
    func formattedLocation() -> String? {
        let placeTitle = place?.title
        let locationName = location?.name
        let parts = [placeTitle, locationName].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: " • ")
    }
}

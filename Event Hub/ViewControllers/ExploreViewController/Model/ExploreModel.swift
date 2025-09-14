//
//  ExploreModel.swift
//  Event Hub
//
//  Created by Варвара Уткина on 11.09.2025.
//

import Foundation

struct ExploreModel {
    let header: ExploreHeader
    let upcomingEvents: EventsModel
    let nearbyEvents: EventsModel
    
    static func getExploreModel() -> ExploreModel {
        ExploreModel(
            header: ExploreHeader.getHeader(),
            upcomingEvents: EventsModel.getUpcomingEvents(),
            nearbyEvents: EventsModel.getNearbyEvents()
        )
    }
}

struct ExploreHeader {
    let filters: [ExploreFilterItem]
    
    
    static func getHeader() -> ExploreHeader {
        ExploreHeader(filters: ExploreFilterItem.getFilters())
    }
}

struct EventsModel {
    let title: String
    let seeAll: String
    let events: [Event]
    
    static func getUpcomingEvents() -> EventsModel {
        EventsModel(
            title: "Upcoming Events",
            seeAll: "See All",
            events: Event.getEvents()
        )
    }
    static func getNearbyEvents() -> EventsModel {
        EventsModel(
            title: "Nearby You",
            seeAll: "See All",
            events: Event.getOtherEvents()
        )
    }
}

struct Event {
    let title: String
    let imageName: String
    let date: String
    let visitorsPhoto: [String]
    let address: String
    
    static func getEvents() -> [Event] {
        [
            Event(
                title: "International Band Mu...",
                imageName: "eventImage",
                date: "11 june" ,
                visitorsPhoto: Array(repeating: "personImage", count: 23),
                address: "36 Guild Street London, UK"
            ),
            Event(
                title: "Jo Malone London’s Mo..",
                imageName: "eventImage",
                date: "11 june" ,
                visitorsPhoto: Array(repeating: "personImage", count: 17),
                address: "Radius Gallery • Santa Cruz, CA"
            )
        ]
    }
    
    static func getOtherEvents() -> [Event] {
        [
            Event(
                title: "International Band Mu...",
                imageName: "eventImage",
                date: "11 june" ,
                visitorsPhoto: Array(repeating: "personImage", count: 40),
                address: "36 Guild Street London, UK"
            ),
            Event(
                title: "Jo Malone London’s Mo..",
                imageName: "eventImage",
                date: "11 june" ,
                visitorsPhoto: Array(repeating: "personImage", count: 10),
                address: "Radius Gallery • Santa Cruz, CA"
            )
        ]
    }
}

struct ExploreFilterItem {
    let title: String
    let imageName: String
    let hexColor: String
    
    static func getFilters() -> [ExploreFilterItem] {
        [
            ExploreFilterItem(title: "Sports", imageName: "ballImage", hexColor: "#F0635A"),
            ExploreFilterItem(title: "Music", imageName: "ballImage", hexColor: "#F59762"),
            ExploreFilterItem(title: "Food", imageName: "ballImage", hexColor: "#29D697"),
            ExploreFilterItem(title: "Art", imageName: "ballImage", hexColor: "#46CDFB")
        ]
    }
}

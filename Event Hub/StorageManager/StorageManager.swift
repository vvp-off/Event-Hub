//
//  StorageManager.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import Foundation


final class StorageManager {
    
    static let shared = StorageManager()
    private let networkManager = NetworkManager()
    
    var nearbyEvents: [Event] = []
    var upcomingEvents: [Event] = []


    func loadEvents(
        slug: String? = nil,
        upcomingOnly: Bool = true,
        limit: Int = 1,
        completion: (([Event]) -> Void)? = nil
    ) {
        var collectedEvents: [Event] = []
        var seenIds = Set<Int>()
        var page = 1
        let dateStart = Date()
        guard let dateEnd = Calendar.current.date(byAdding: .day, value: 7, to: dateStart) else { return }
        
        func fetchNextPage() {
            let remaining = max(0, limit - collectedEvents.count)
            networkManager.fetchEvents(count: remaining == 0 ? limit : remaining,
                                       slug: slug,
                                       page: page,
                                       dateStart: dateStart,
                                       dateEnd: dateEnd) { [weak self] result in
                switch result {
                case .success(let response):
                    guard !response.results.isEmpty else {
                        DispatchQueue.main.async {
                            self?.assignEvents(collectedEvents, slug: slug)
                            completion?(collectedEvents)
                        }
                        return
                    }
                    let range = dateStart...dateEnd
                    for event in response.results {
                        guard let self = self else { break }
                        if seenIds.contains(event.id) { continue }
                        guard let selectedDate = self.selectEventDate(event, within: range) else { continue }
                        let fixedEvent = self.buildEvent(event, with: selectedDate)
                        seenIds.insert(event.id)
                        collectedEvents.append(fixedEvent)
                        if collectedEvents.count >= limit { break }
                    }

                    if collectedEvents.count < limit {
                        page += 1
                        fetchNextPage()
                    } else {
                        DispatchQueue.main.async {
                            self?.assignEvents(collectedEvents, slug: slug)
                            completion?(collectedEvents)
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Error fetching events page \(page): \(error.rawValue)")
                    DispatchQueue.main.async { completion?(collectedEvents) }
                }
            }
        }
        
        fetchNextPage()
    }

    private func assignEvents(_ events: [Event], slug: String?) {
        if let slug = slug {
            nearbyEvents = events
            print("❌❌❌События для города \(slug): \(nearbyEvents)")
        } else {
            upcomingEvents = events
            print("❌❌❌Ближайшие события: \(upcomingEvents)")
        }
    }

    private func selectEventDate(_ event: Event, within range: ClosedRange<Date>) -> EventDate? {
        let now = Date()
        let maxDurationForInclusion: TimeInterval = 60 * 24 * 60 * 60 // 60 дней
        let maxDurationForOngoingFallback: TimeInterval = 30 * 24 * 60 * 60 // 30 дней
        var bestOngoing: EventDate?

        for date in event.dates {
            let startDate = Date(timeIntervalSince1970: date.start)
            let endDate = Date(timeIntervalSince1970: date.end)
            let duration = endDate.timeIntervalSince(startDate)

            // Отсекаем «вечные»/аномально длинные интервалы
            if duration > maxDurationForInclusion { continue }

            // 1) Предпочитаем даты, которые начинаются в окне и ещё не закончились
            if range.contains(startDate) && endDate >= now { return date }

            // 2) Как запасной вариант берём идущее сейчас событие, начавшееся до окна,
            //    если его длительность разумная
            if startDate < range.lowerBound && endDate >= now && duration <= maxDurationForOngoingFallback {
                if bestOngoing == nil || endDate < Date(timeIntervalSince1970: bestOngoing!.end) {
                    bestOngoing = date
                }
            }

            // Ранний выход, если дальнейшие даты начинаются позже окна
            if startDate > range.upperBound { break }
        }

        return bestOngoing
    }

    private func buildEvent(_ event: Event, with date: EventDate) -> Event {
        let firstImage = event.images.first ?? EventImage(image: "")
        return Event(
            id: event.id,
            dates: [date],
            title: event.title,
            slug: event.slug,
            place: event.place,
            images: [firstImage],
            favoritesCount: event.favoritesCount,
            bodyText: event.bodyText,
            siteUrl: event.siteUrl,
            location: event.location,
            participants: event.participants,
            isFavorite: event.isFavorite
        )
    }
}






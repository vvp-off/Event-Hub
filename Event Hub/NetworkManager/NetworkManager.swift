//
//  NetworkManager.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import UIKit

enum NetworkError: String, Error {
    case badURL = "❌Error - bad URL"
    case sessionError = "❌Error - URLSession"
    case data = "❌Error - no data"
    case decode = "❌Error - JSON decoder error / response"
    case date = "❌Error - bad date"
}

final class NetworkManager {
    
    private let scheme = "https"
    private let host = "kudago.com"
    private let pathComponent = "/public-api/v1.4/"
    
    
    private func performRequest<T: Decodable>(
        url: URL?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = url else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                DispatchQueue.main.async { completion(.failure(.sessionError)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.data)) }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("❌ Decode error:", error)
                DispatchQueue.main.async { completion(.failure(.decode)) }
            }
        }.resume()
    }
    
    // MARK: - Все города
    func fetchAllCities(completion: @escaping (Result<[City], NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(pathComponent)locations"
        
        performRequest(url: urlComponents.url, completion: completion)
    }
    
    // MARK: - Детали города
    func fetchCityDetail(slug: String, completion: @escaping (Result<CityDetail, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(pathComponent)locations/\(slug)"
        
        performRequest(url: urlComponents.url, completion: completion)
    }
    
    // MARK: - Эвент по ID
    func fetchEventWithID(
        _ id: Int,
        completion: @escaping (Result<Event, NetworkError>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(pathComponent)events/\(id)/"
        urlComponents.queryItems = [
            URLQueryItem(name: "expand", value: "place,dates,location")
        ]
        performRequest(url: urlComponents.url, completion: completion)
    }
    
    // MARK: - Массив эвентов по ID
    func fetchEventsWithIDs(
        _ ids: [Int],
        completion: @escaping (Result<[Event], NetworkError>) -> Void
    ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(pathComponent)events/"
        
        let idsString = ids.map(String.init).joined(separator: ",")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "ids", value: idsString),
            URLQueryItem(name: "expand", value: "place,dates,location")
        ]
        
        performRequest(url: urlComponents.url, completion: completion)
        
    }
    
    // MARK: - Массив эвентов
    func fetchEvents(
        count: Int = 100,
        slug: String? = nil,
        page: Int = 1,
        dateStart: Date,
        dateEnd: Date,
        completion: @escaping (Result<EventsResponse, NetworkError>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(pathComponent)events/"
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "page_size", value: "\(count)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "fields", value: "id,dates,title,place,slug,images,favorites_count,location"),
            URLQueryItem(name: "expand", value: "place,dates,location")
        ]
        
        if let slug = slug {
            queryItems.append(URLQueryItem(name: "location", value: slug))
        }
        
        let actualSince = Int(dateStart.timeIntervalSince1970)
        let actualUntil = Int(dateEnd.timeIntervalSince1970)
        
        queryItems.append(contentsOf: [
            URLQueryItem(name: "actual_since", value: "\(actualSince)"),
            URLQueryItem(name: "actual_until", value: "\(actualUntil)")
        ])
        // Серверная сортировка по дате начала ближайшие сначала
        queryItems.append(URLQueryItem(name: "ordering", value: "dates.start"))
        
        urlComponents.queryItems = queryItems
        performRequest(url: urlComponents.url, completion: completion)
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        if let cached = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            completion(cached)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data), error == nil {
                ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
}

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}


//
//  City.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import Foundation


struct City: Codable {
    let slug: String
    let name: String
}

struct CityDetail: Codable {
    let slug: String
    let name: String
    let coords: Coordinates?
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

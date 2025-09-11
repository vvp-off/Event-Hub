//
//  ExploreModel.swift
//  Event Hub
//
//  Created by Варвара Уткина on 11.09.2025.
//

import Foundation

struct ExploreModel {
    let header: ExploreHeader
    
    static func getExploreModel() -> ExploreModel {
        ExploreModel(header: ExploreHeader.getHeader())
    }
}

struct ExploreHeader {
    let filters: [ExploreFilterItem]
    
    
    static func getHeader() -> ExploreHeader {
        ExploreHeader(filters: ExploreFilterItem.getFilters())
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

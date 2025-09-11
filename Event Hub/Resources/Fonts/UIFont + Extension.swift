//
//  UIFont + Extension.swift
//  AiPhotoApp
//
//  Created by Варвара Уткина on 22.04.2025.
//

import UIKit

extension UIFont {
    static func airbnb(_ type: AirbnbCereal, size: CGFloat) -> UIFont {
        type.font(size: size)
    }
}

// MARK: - Inter Font
enum AirbnbCereal: String {
    case book = "AirbnbCerealWBk"
    case medium = "AirbnbCerealWMd"
    case bold = "AirbnbCerealWBd"
    
    private var fallbackWeight: UIFont.Weight {
        switch self {
        case .book: .regular // 400
        case .medium: .medium // 500
        case .bold: .bold // 700
        }
    }
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            assertionFailure("Font \(rawValue) was not not found. Add it to your project and Info.plist")
            return UIFont.systemFont(ofSize: size, weight: fallbackWeight)
        }
        return font
    }
}

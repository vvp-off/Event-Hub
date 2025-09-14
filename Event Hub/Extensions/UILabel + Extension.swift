//
//  UILabel + Extension.swift
//  AiPhotoApp
//
//  Created by Варвара Уткина on 23.04.2025.
//

import UIKit

extension UILabel {
    static func create(
        text: String = "",
        color: UIColor = .black,
        font: UIFont
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        return label
    }
}

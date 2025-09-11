//
//  UIView + Extension.swift
//  AiPhotoApp
//
//  Created by Варвара Уткина on 22.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}

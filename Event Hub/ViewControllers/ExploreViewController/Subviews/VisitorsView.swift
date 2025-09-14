//
//  VisitorsView.swift
//  Event Hub
//
//  Created by Варвара Уткина on 14.09.2025.
//

import UIKit
import SnapKit

final class VisitorsView: UIView {
    
    private enum Drawing {
        static var imageOverlay: CGFloat { 16 }
        
        static var imageSize: CGSize { CGSize(width: 24, height: 24) }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func config(with images: [String]) {
        let persons = Array(images.prefix(3))
        var imageViews: [UIImageView] = []
        
        persons.forEach { person in
            let imageView = UIImageView()
            imageView.image = UIImage(named: person)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = Drawing.imageSize.height / 2
            imageView.clipsToBounds = true
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
            
            imageViews.append(imageView)
        }
        
        let reversedImages = imageViews.reversed()
        reversedImages.enumerated().forEach { (index, imageView) in
            addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(Drawing.imageSize)
                make.trailing.equalToSuperview().inset(CGFloat(index) * Drawing.imageOverlay)
            }
        }
        
        snp.updateConstraints { make in
            make.width.equalTo(
                Drawing.imageSize.width + CGFloat(reversedImages.count - 1) * Drawing.imageOverlay
            )
        }
        
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        
        snp.makeConstraints { make in
            make.height.equalTo(Drawing.imageSize.height)
            make.width.equalTo(Drawing.imageSize.width + 2 * Drawing.imageOverlay)
        }
    }
}

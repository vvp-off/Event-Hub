//
//  FilterCollectionViewCell.swift
//  Event Hub
//
//  Created by Варвара Уткина on 10.09.2025.
//

import UIKit
import SnapKit

final class FilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "FilterCollectionViewCell"
    
    private enum Drawing {
        static var height: CGFloat { 39 }
        static var spacing: CGFloat { 8 }
        static var horizontalInset: CGFloat { 16.5 }
        static var imageSize: CGSize { CGSize(width: 17.6, height: 17.6) }
    }
    
    // MARK: - UI Elements
    private let colorView = UIView()
    private let mainStack = UIStackView.create(axis: .horizontal, spacing: Drawing.spacing)
    private let imageView = UIImageView()
    private let titleLabel = UILabel.create(
        color: .white,
        font: UIFont.airbnb(.book, size: 15)
    )
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
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
    func configure(with model: ExploreFilterItem) {
        colorView.backgroundColor = UIColor.fromHex(model.hexColor)
        colorView.layer.cornerRadius = bounds.height / 2
        colorView.clipsToBounds = true
        
        titleLabel.text = model.title
        imageView.image = UIImage(named: model.imageName)
    }
    
    func calculateSize(for model: ExploreFilterItem) -> CGSize {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.airbnb(.book, size: 15)
        ]
        
        let textSize = (model.title as NSString).size(withAttributes: textAttributes)
        
        let totalWidth = Drawing.horizontalInset * 2 +
        Drawing.imageSize.width +
        Drawing.spacing +
        textSize.width
        
        return CGSize(width: totalWidth, height: Drawing.height)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(colorView)
        colorView.addSubview(mainStack)
        mainStack.addArrangedSubviews(imageView, titleLabel)
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.imageSize)
        }
    }
}

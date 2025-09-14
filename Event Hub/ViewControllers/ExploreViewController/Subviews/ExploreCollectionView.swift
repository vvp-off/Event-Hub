//
//  ExploreCollectionView.swift
//  Event Hub
//
//  Created by Варвара Уткина on 14.09.2025.
//

import UIKit
import SnapKit

final class ExploreCollectionView: UIView {
    
    private enum Drawing {
        static var height: CGFloat { 309 }
        static var horizontalInset: CGFloat { 24 }
        
        static var collectionSize: CGSize { CGSize(width: 237, height: 275) }
        static var horizontalCollectionSpacing: CGFloat { 16 }
        static var verticalCollectionInset: CGFloat { 10 }
        
        static var stackHeight: CGFloat { 34 }
        static var seeAllImageSize: CGSize { CGSize(width: 7, height: 9)}
        static var seeAllWidth: CGFloat { 56 }
    }
    
    // MARK: - UI Elements
    let collection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = Drawing.horizontalCollectionSpacing
        collectionLayout.itemSize = Drawing.collectionSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        
        collection.contentInsetAdjustmentBehavior = .never
        collection.contentInset.left = Drawing.horizontalInset
        collection.contentInset.right = Drawing.horizontalInset
        collection.contentInset = UIEdgeInsets(
            top: 0,
            left: Drawing.horizontalInset,
            bottom: 0,
            right: Drawing.horizontalInset
        )
        
        collection.register(
            EventCollectionViewCell.self,
            forCellWithReuseIdentifier: EventCollectionViewCell.identifier
        )
        return collection
    }()
    private let titleStack = UIStackView.create(axis: .horizontal, spacing: 0)
    private let titleLabel = UILabel.create(
        color: .exploreTitle,
        font: UIFont.systemFont(ofSize: 18, weight: .semibold)
    )
    private let seeAllStack = UIStackView.create(axis: .horizontal, spacing: 2)
    private let seeAllLabel = UILabel.create(
        color: .exploreGray,
        font: UIFont.airbnb(.book, size: 14)
    )
    private let seeAllImage = UIImageView()
    
    // MARK: - Dependencies
    weak var delegate: ExploreViewControllerDelegate?
    
    // MARK: - Private Properties
    private var model: EventsModel?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func config(with model: EventsModel) {
        self.model = model
        titleLabel.text = model.title
        seeAllLabel.text = model.seeAll
        seeAllImage.image = UIImage(named: "seeAllArrow")
        
        collection.reloadData()
    }
    
    // MARK: - Actions
    @objc private func seeAllTapped() {
        delegate?.openSeeAllVC()
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        addSubviews(titleStack, collection)
        titleStack.addArrangedSubviews(titleLabel, seeAllStack)
        seeAllStack.addArrangedSubviews(seeAllLabel, seeAllImage)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
        seeAllStack.isUserInteractionEnabled = true
        seeAllStack.addGestureRecognizer(tapGesture)
        
        collection.dataSource = self
        seeAllImage.contentMode = .scaleAspectFit
        seeAllStack.alignment = .center
        titleStack.alignment = .center
        
        snp.makeConstraints { make in
            make.height.equalTo(Drawing.height)
        }
        titleStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
            make.top.equalToSuperview()
            make.height.equalTo(Drawing.stackHeight)
        }
        collection.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(Drawing.collectionSize.height)
        }
        seeAllStack.snp.makeConstraints { make in
            make.width.equalTo(Drawing.seeAllWidth)
        }
        seeAllImage.snp.makeConstraints { make in
            make.size.equalTo(Drawing.seeAllImageSize)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ExploreCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let model else { return 0 }
        return model.events.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EventCollectionViewCell.identifier,
            for: indexPath
        ) as? EventCollectionViewCell else { return UICollectionViewCell() }
        guard let model, model.events.indices.contains(indexPath.item) else { return UICollectionViewCell() }
        let event = model.events[indexPath.item]
        cell.configure(with: event)
        return cell
    }
}

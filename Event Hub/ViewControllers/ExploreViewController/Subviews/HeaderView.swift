//
//  HeaderView.swift
//  Event Hub
//
//  Created by Варвара Уткина on 09.09.2025.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    
    private enum Drawing {
        static var height: CGFloat { 196 }
        static var cornerRadius: CGFloat { 33 }
        
        static var blueViewBottomInset: CGFloat { 17 }
    
        static var horizontalCollectionSpacing: CGFloat { 11 }
        static var leftCollectionInset: CGFloat { 24 }
        static var collectionHeight: CGFloat { 39 }
    }
    
    // MARK: - UI Elements
    private let blueView: UIView = {
        let blueView = UIView()
        blueView.backgroundColor = .search
        blueView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        blueView.layer.cornerRadius = Drawing.cornerRadius
        blueView.clipsToBounds = true
        return blueView
    }()
    private let filterCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = Drawing.horizontalCollectionSpacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        
        collection.contentInsetAdjustmentBehavior = .never
        collection.contentInset.left = Drawing.leftCollectionInset
        collection.contentInset.right = Drawing.leftCollectionInset
        
        collection.register(
            FilterCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterCollectionViewCell.identifier
        )
        return collection
    }()
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private var model: ExploreHeader?
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    // MARK: - Actions
    
    // MARK: - Public Methods
    func config(with model: ExploreHeader) {
        self.model = model
        filterCollection.reloadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        addSubviews(blueView, filterCollection)
        
        filterCollection.dataSource = self
        filterCollection.delegate = self
        
        snp.makeConstraints { make in
            make.height.equalTo(Drawing.height)
        }
        blueView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Drawing.blueViewBottomInset)
        }
        filterCollection.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(Drawing.collectionHeight)
        }
    }
    
    // MARK: - Private Methods
}

// MARK: - UICollectionViewDataSource
extension HeaderView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let model else { return 0 }
        return model.filters.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCollectionViewCell.identifier,
            for: indexPath
        ) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        guard let model, model.filters.indices.contains(indexPath.row) else { return UICollectionViewCell() }
        let filterItem = model.filters[indexPath.row]
        cell.configure(with: filterItem)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let model else { return CGSize(width: 0, height: 0) }
        let filterItem = model.filters[indexPath.row]
        let tempCell = FilterCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 39))
        tempCell.configure(with: filterItem)
        tempCell.layoutIfNeeded()
        
        let size = tempCell.contentView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        
        return CGSize(width: size.width, height: Drawing.collectionHeight)
    }
}

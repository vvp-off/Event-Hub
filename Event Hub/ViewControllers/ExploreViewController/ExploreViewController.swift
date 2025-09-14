//
//  ExploreViewController.swift
//  Event Hub
//
//  Created by Варвара Уткина on 09.09.2025.
//

import UIKit
import SnapKit

protocol ExploreViewControllerDelegate: AnyObject {
    func openSeeAllVC()
}

final class ExploreViewController: UIViewController {
    
    private enum Drawing {
        static var topCollectionInset: CGFloat { 21.5 }
    }
    
    // MARK: - UI Elements
    private let headerView = HeaderView()
    private let upcomingCollectionView = ExploreCollectionView()
    private let nearbyCollectionView = ExploreCollectionView()
    
    // MARK: - Public Properties
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let model = ExploreModel.getExploreModel()
        headerView.config(with: model.header)
        upcomingCollectionView.config(with: model.upcomingEvents)
        nearbyCollectionView.config(with: model.nearbyEvents)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(headerView, upcomingCollectionView, nearbyCollectionView)
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.collection.isScrollEnabled = true

        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        upcomingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        nearbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(upcomingCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - ExploreViewControllerDelegate
extension ExploreViewController: ExploreViewControllerDelegate {
    func openSeeAllVC() {
        let tempVC = TempViewController()
        present(tempVC, animated: true)
    }
}

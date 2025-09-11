//
//  ExploreViewController.swift
//  Event Hub
//
//  Created by Варвара Уткина on 09.09.2025.
//

import UIKit
import SnapKit

final class ExploreViewController: UIViewController {
    
    // MARK: - UI Elements
    private let headerView: HeaderView
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let model: ExploreModel
    
    // MARK: - Initializers
    init() {
        model = ExploreModel.getExploreModel()
        headerView = HeaderView(model: model.header)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    
    // MARK: - Actions
    
    // MARK: - Public Methods
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
}

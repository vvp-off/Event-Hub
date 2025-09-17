//
//  FavoritesVC.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import UIKit


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemGroupedBackground
        
        setupTableView()
        setupNavBar()
        loadTestData()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavBar() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearch)
        )
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func didTapSearch() {
        print("Search tapped")
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        navigationItem.searchController = searchController
    }
    
    private func loadTestData() {
        events = [
            Event(date: "Wed, Apr 28", time: "5:30 PM",
                  title: "Jo Malone London’s Mother’s Day Presents",
                  location: "Radius Gallery · Santa Cruz, CA",
                  imageName: "test foto", isFavorite: true),
            Event(date: "Sat, May 1", time: "2:00 PM",
                  title: "A Virtual Evening of Smooth Jazz",
                  location: "Lot 13 · Oakland, CA",
                  imageName: "test foto", isFavorite: false)
        ]
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.dateLabel.text = "\(event.date) · \(event.time)"
        cell.titleLabel.text = event.title
        cell.locationLabel.text = event.location
        cell.eventImageView.image = UIImage(named: event.imageName)
        cell.favoriteButton.setImage(UIImage(systemName: event.isFavorite ? "bookmark.fill" : "bookmark"), for: .normal)
        return cell
    }
}

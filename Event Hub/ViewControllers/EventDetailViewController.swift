//
//  EventDetailViewController.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import UIKit

final class EventDetailViewController: UIViewController {
    private let networkManager = NetworkManager()

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let headerImageView = UIImageView()
    private let titleLabel = UILabel()

    private let dateIcon = UIImageView(image: UIImage(named: "Calendar"))
    private let dateTitleLabel = UILabel()
    private let dateSubtitleLabel = UILabel()

    private let placeIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let placeTitleLabel = UILabel()
    private let placeSubtitleLabel = UILabel()

    private let organizerIcon = UIImageView()
    private let organizerTitleLabel = UILabel()
    private let organizerSubtitleLabel = UILabel()

    private let aboutTitleLabel = UILabel()
    private let aboutTextLabel = UILabel()

    // Header overlay buttons
    private let bookmarkButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)

    private var eventId: Int?
    private var event: Event?

    private let loadingOverlay = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    convenience init(eventId: Int) {
        self.init()
        self.eventId = eventId
    }

    convenience init(event: Event) {
        self.init()
        self.event = event
        self.eventId = event.id
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Event Details"
        
        navigationController?.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.titlePositionAdjustment = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        
        setupUI()
        showLoading(true)
        bindIfAvailable()
        fetchFullDetails()
    }

    private func setupUI() {
        // Header image
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true

        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        // Info rows styling
        [dateTitleLabel, placeTitleLabel, organizerTitleLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .label
            label.numberOfLines = 0
        }
        [dateSubtitleLabel, placeSubtitleLabel, organizerSubtitleLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
        }
        dateIcon.tintColor = .systemBlue
        dateIcon.contentMode = .scaleAspectFit
        dateIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        dateIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true

        placeIcon.tintColor = .systemBlue
        placeIcon.contentMode = .scaleAspectFit
        placeIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        placeIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true

        organizerIcon.layer.cornerRadius = 14
        organizerIcon.clipsToBounds = true
        organizerIcon.backgroundColor = .secondarySystemBackground
        organizerIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        organizerIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true

        // About
        aboutTitleLabel.text = "About Event"
        aboutTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        aboutTitleLabel.textColor = .label

        aboutTextLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        aboutTextLabel.textColor = .secondaryLabel
        aboutTextLabel.numberOfLines = 0

        // Header overlay buttons
        setupHeaderButtons()

        // Layout
        contentStack.axis = .vertical
        contentStack.spacing = 16

        let dateV = makeInfoRow(icon: dateIcon, title: dateTitleLabel, subtitle: dateSubtitleLabel)
        let placeV = makeInfoRow(icon: placeIcon, title: placeTitleLabel, subtitle: placeSubtitleLabel)
        let orgV = makeInfoRow(icon: organizerIcon, title: organizerTitleLabel, subtitle: organizerSubtitleLabel)

        [ titleLabel, dateV, placeV, orgV, aboutTitleLabel, aboutTextLabel].forEach { contentStack.addArrangedSubview($0) }

        view.addSubview(headerImageView)
        view.addSubview(scrollView)
        view.addSubview(bookmarkButton)
        view.addSubview(shareButton)
        
        // Ensure buttons are on top
        view.bringSubviewToFront(bookmarkButton)
        view.bringSubviewToFront(shareButton)
        
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 245),
            
            scrollView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Header overlay buttons
            bookmarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 36),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 36),
            
            shareButton.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -16),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 36),
            shareButton.heightAnchor.constraint(equalToConstant: 36)
        ])

        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])

        // Loading overlay (non-blocking look while content loads)
        loadingOverlay.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        view.addSubview(loadingOverlay)
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingIndicator.startAnimating()
        loadingOverlay.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }

    private func makeInfoRow(icon: UIImageView, title: UILabel, subtitle: UILabel) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 12
        let v = UIStackView(arrangedSubviews: [title, subtitle])
        v.axis = .vertical
        v.spacing = 2
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(v)
        return stack
    }

    func configure(with event: Event) {
        self.event = event
        self.eventId = event.id
        bindIfAvailable()
    }

    private func bindIfAvailable() {
        guard let event = event else { return }
        titleLabel.text = event.title
        dateTitleLabel.text = Date(timeIntervalSince1970: event.dates.first?.start ?? 0).formatted("d MMMM, yyyy")
        dateSubtitleLabel.text = Date(timeIntervalSince1970: event.dates.first?.start ?? 0).formatted("EEEE, h:mm a") + " - " + Date(timeIntervalSince1970: event.dates.first?.end ?? 0).formatted("h:mm a")
        placeTitleLabel.text = event.place?.title ?? "—"
        placeSubtitleLabel.text = event.place?.address ?? event.location?.name
        organizerTitleLabel.text = event.participants?.first?.agent.title ?? "—"
        organizerSubtitleLabel.text = "Organizer"
        aboutTextLabel.text = (event.bodyText ?? "").htmlStripped
        
        // Update bookmark button state
        let isFavorite = event.isFavorite ?? false
        bookmarkButton.setImage(UIImage(systemName: isFavorite ? "bookmark.fill" : "bookmark"), for: .normal)

        if let header = event.images.first?.image {
            networkManager.fetchImage(from: header) { [weak self] image in
                DispatchQueue.main.async { self?.headerImageView.image = image }
            }
        }
        if let avatar = event.participants?.first?.agent.images?.first?.image {
            networkManager.fetchImage(from: avatar) { [weak self] image in
                DispatchQueue.main.async { self?.organizerIcon.image = image }
            }
        }
    }

    private func fetchFullDetails() {
        guard let eventId = eventId else { return }
        networkManager.fetchEventWithID(eventId) { [weak self] result in
            switch result {
            case .success(let fullEvent):
                self?.event = fullEvent
                DispatchQueue.main.async {
                    self?.bindIfAvailable()
                    self?.showLoading(false)
                }
            case .failure:
                DispatchQueue.main.async { self?.showLoading(false) }
            }
        }
    }

    private func setupHeaderButtons() {
        // Bookmark button (top right)
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = .white
        bookmarkButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bookmarkButton.layer.cornerRadius = 10
        bookmarkButton.contentMode = .center
        bookmarkButton.imageView?.contentMode = .scaleAspectFit
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        
        // Share button (bottom right)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .white
        shareButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        shareButton.layer.cornerRadius = 10
        shareButton.contentMode = .center
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    @objc private func bookmarkTapped() {
        guard var event = event else { return }
        let isCurrentlyFavorite = event.isFavorite ?? false
        let newState = !isCurrentlyFavorite
        
        // Update local event model
        self.event = Event(
            id: event.id,
            dates: event.dates,
            title: event.title,
            slug: event.slug,
            place: event.place,
            images: event.images,
            favoritesCount: event.favoritesCount,
            bodyText: event.bodyText,
            siteUrl: event.siteUrl,
            location: event.location,
            participants: event.participants,
            isFavorite: newState
        )
        
        // Update UI immediately
        bookmarkButton.setImage(UIImage(systemName: newState ? "bookmark.fill" : "bookmark"), for: .normal)
        
        // TODO: Update in storage/network
        print("Bookmark toggled: \(newState) for event \(event.id)")
    }
    
    @objc private func shareTapped() {
        guard let event = event else { return }
        
        let shareText = "\(event.title)\n\(event.formattedLocation() ?? "")"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }

    private func showLoading(_ flag: Bool) {
        loadingOverlay.isHidden = !flag
        if flag { loadingIndicator.startAnimating() } else { loadingIndicator.stopAnimating() }
    }
}

private extension Date {
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

private extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }
        return attributed.string
    }
}



//
//  EventCollectionViewCell.swift
//  Event Hub
//
//  Created by Варвара Уткина on 14.09.2025.
//

import UIKit
import SnapKit

final class EventCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventCollectionViewCell"
    
    private enum Drawing {
        static var cornerRadius: CGFloat { 18 }
        static var horizontalInset: CGFloat { 14 }
        static var verticalInset: CGFloat { 10 }
        
        static var imageCornerRadius: CGFloat { 10 }
        static var imageSize: CGSize { CGSize(width: 218, height: 131) }
        static var imageTopInset: CGFloat { 9 }
        
        static var dateSize: CGSize { CGSize(width: 45, height: 45) }
        static var dateInset: CGFloat { 8 }
        static var dateTextTopInset: CGFloat { 3 }
        
        static var markerCornerRadius: CGFloat { 7 }
        static var markerSize: CGSize { CGSize(width: 30, height: 30) }
        static var markerImageSize: CGSize { CGSize(width: 14, height: 14) }
        
        static var locationStackSpacing: CGFloat { 5 }
        static var locationHeight: CGFloat { 17 }
        static var locationLeftInset: CGFloat { 16 }
        static var locationSize: CGSize { CGSize(width: 16, height: 16) }
        
        static var personInset: CGFloat { 10 }
        static var personTopInset: CGFloat { 12 }
        static var personHeight: CGFloat { 24 }
    }
    
    // MARK: - UI Elements
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Drawing.cornerRadius
        view.clipsToBounds = false
        
        view.layer.shadowColor = UIColor.exploreShodow.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1
        
        return view
    }()
    private let rectangleView: UIView = {
        let rect = UIView()
        rect.backgroundColor = .white
        rect.layer.cornerRadius = Drawing.cornerRadius
        rect.clipsToBounds = false
        
        rect.layer.shadowColor = UIColor.exploreShodow.cgColor
        rect.layer.shadowOffset = CGSize(width: 0, height: 8)
        rect.layer.shadowRadius = 30
        rect.layer.shadowOpacity = 1
        
        return rect
    }()
    private let imageView = UIImageView()
    private let dateView: UIView = {
        let dateV = UIView()
        dateV.backgroundColor = .white.withAlphaComponent(0.7)
        dateV.layer.cornerRadius = Drawing.imageCornerRadius
        dateV.clipsToBounds = true
        return dateV
    }()
    private let dateLabel = UILabel()
    private let markerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.layer.cornerRadius = Drawing.markerCornerRadius
        view.clipsToBounds = true
        return view
    }()
    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookmarkEmpty")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel = UILabel.create(font: UIFont.systemFont(ofSize: 18, weight: .medium))
    private let locationStack = UIStackView.create(
        axis: .horizontal,
        alignment: .center,
        spacing: Drawing.locationStackSpacing
    )
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationTag")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let locationLabel = UILabel.create(
        color: .locationGray,
        font: UIFont.airbnb(.book, size: 13)
    )
    private let personStack = UIStackView.create(
        axis: .horizontal,
        alignment: .center,
        spacing: Drawing.personInset
    )
    private let personImages = VisitorsView()
    private let goingLabel = UILabel.create(
        color: .exploreGoing,
        font: UIFont.systemFont(ofSize: 12, weight: .medium)
    )
    
    // MARK: - Private Properties
    private var isMarked = false {
        didSet {
            updateBookmark()
        }
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
    
    // MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }
    
    // MARK: - Public Methods
    func configure(with model: Event) {
        imageView.image = UIImage(named: model.imageName)
        setDateText(for: model.date.uppercased())
        titleLabel.text = model.title
        locationLabel.text = model.address
        personImages.config(with: model.visitorsPhoto)
        goingLabel.text = getGoingText(for: model.visitorsPhoto)
    }
    
    // MARK: - Actions
    @objc private func bookmarkTapped() {
        isMarked.toggle()
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkTapped))
        rectangleView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        markerView.isUserInteractionEnabled = true
        markerView.addGestureRecognizer(tapGesture)
        
        contentView.addSubviews(shadowView, rectangleView)
        rectangleView.addSubviews(imageView, titleLabel, personStack, locationStack)
        imageView.addSubviews(dateView, markerView)
        dateView.addSubview(dateLabel)
        markerView.addSubview(markerImageView)
        personStack.addArrangedSubviews(personImages, goingLabel)
        locationStack.addArrangedSubviews(locationImageView, locationLabel)
        
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawing.imageCornerRadius
        imageView.clipsToBounds = true
        
        shadowView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(Drawing.verticalInset)
        }
        rectangleView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(Drawing.verticalInset)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.imageSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(Drawing.imageTopInset)
        }
        dateView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.dateSize)
            make.top.leading.equalToSuperview().inset(Drawing.dateInset)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Drawing.dateTextTopInset)
            make.horizontalEdges.equalToSuperview()
        }
        markerView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.markerSize)
            make.top.trailing.equalToSuperview().inset(Drawing.dateInset)
        }
        markerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Drawing.markerImageSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Drawing.horizontalInset)
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
        }
        personStack.snp.makeConstraints { make in
            make.height.equalTo(Drawing.personHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(Drawing.personTopInset)
            make.leading.equalToSuperview().inset(Drawing.locationLeftInset)
        }
        locationStack.snp.makeConstraints { make in
            make.height.equalTo(Drawing.locationHeight)
            make.leading.equalToSuperview().inset(Drawing.locationLeftInset)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Drawing.locationHeight)
        }
        locationImageView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.locationSize)
        }
        
        updateShadowPath()
    }
    
    // MARK: - Private Methods
    private func updateShadowPath() {
        let shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            cornerRadius: Drawing.cornerRadius
        )
        shadowView.layer.shadowPath = shadowPath.cgPath
    }
    
    private func getGoingText(for images: [String]) -> String {
        guard images.count > 3 else { return "" }
        return "+\(images.count - 3) Going"
    }
    
    private func updateBookmark() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            let imageName = isMarked
            ? "bookmarkFill"
            : "bookmarkEmpty"
            markerImageView.image = UIImage(named: imageName)
        }
    }
    
    private func setDateText(for text: String) {
        guard !text.isEmpty else { return }
        dateLabel.textColor = .explorePink
        let attributedString = NSMutableAttributedString(string: text)
        
        let numberText = String(text.prefix(3))
        let numberRange = (text as NSString).range(of: numberText)

        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 18, weight: .light),
            range: numberRange
        )
        
        let monthText = String(text.dropFirst(3))
        let monthRange = (text as NSString).range(of: monthText)
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 10, weight: .bold),
            range: monthRange
        )
        dateLabel.attributedText = attributedString
    }
}

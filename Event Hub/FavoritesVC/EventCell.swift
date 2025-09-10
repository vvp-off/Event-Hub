//
//  EventCell.swift
//  Event Hub
//
//  Created by Сергей on 10.09.2025.
//

import UIKit

class EventCell: UITableViewCell {
    
    let eventView = UIView()
    let eventImageView = UIImageView()
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear

        eventView.backgroundColor = .white
        eventView.layer.cornerRadius = 12
        eventView.layer.masksToBounds = true

        
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.layer.cornerRadius = 8
        eventImageView.clipsToBounds = true
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .primaryBlue
        
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .primaryBlack
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        
        locationLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        locationLabel.textColor = .primaryGray
        
        favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        favoriteButton.tintColor = .orangeSelected
        
        let vStackDateAndTitle = UIStackView(arrangedSubviews: [dateLabel, titleLabel])
        vStackDateAndTitle.axis = .vertical
        vStackDateAndTitle.spacing = 4
                
        let vStack = UIStackView(arrangedSubviews: [vStackDateAndTitle, locationLabel])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        let hStack = UIStackView(arrangedSubviews: [eventImageView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 18
        
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventImageView.widthAnchor.constraint(equalToConstant: 79),
            eventImageView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        contentView.addSubview(eventView)
        eventView.addSubview(hStack)
        eventView.addSubview(favoriteButton)
        
        eventView.translatesAutoresizingMaskIntoConstraints = false
        hStack.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            eventView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            hStack.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -12),
            hStack.bottomAnchor.constraint(equalTo: eventView.bottomAnchor, constant: -12),
            
            favoriteButton.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        locationLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

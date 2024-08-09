//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import UIKit
import SnapKit
import Kingfisher

struct NFTTableViewCellModel {
    let image: String
    let name: String
    let authorName: String
    let price: String
    let rating: Int
    
    var isLiked: Bool
    
    static let empty: NFTTableViewCellModel = NFTTableViewCellModel(image: "", name: "", authorName: "", price: "", rating: 0, isLiked: false)
}

final class NFTTableViewCell: UITableViewCell {
    
    static let identifier = "NFTTableViewCell"
    
    private static let totalStars = 5
    
    var model: NFTTableViewCellModel = .empty {
        didSet {
            setup()
        }
    }
    
    private lazy var likeButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption2
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var fromLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "от"
        label.font = .caption1
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Цена"
        label.font = .caption2
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    private lazy var nftStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var nftStackLeft: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var nftStackRight: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var authorView: UIView = {
        let view: UIView = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nftViewContent: UIView = UIView()
    
    
    @objc
    private func likeButtonTapped() {

    }
    
    func setup() {
        backgroundColor = .white
        selectionStyle = .none
        addElements()
        setupConstraints()
        
        nameLabel.text = model.name
        authorLabel.text = model.authorName
        priceValueLabel.text = "\(model.price) ETH"
        
        if let url = URL(string: model.image) {
            nftImageView.kf.setImage(with: url)
        }
        
        model.isLiked ? likeButton.setImage(UIImage(named: "profileImages/likeActive"), for: .normal) :
        likeButton.setImage(UIImage(named: "profileImages/likeNoActive"), for: .normal)
        

        ratingStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let activeStarImage = UIImage(systemName: "star.fill")?
            .withTintColor(.ypYellow, renderingMode: .alwaysOriginal)
        let inactiveStarImage = UIImage(systemName: "star.fill")?
            .withTintColor(.segmentInactive, renderingMode: .alwaysOriginal)
        
        for index in 1...Self.totalStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = index <= model.rating ? activeStarImage : inactiveStarImage
            ratingStackView.addArrangedSubview(starImageView)
            
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }
    
    override func prepareForReuse() {
        for view in ratingStackView.arrangedSubviews {
            ratingStackView.removeArrangedSubview(view)
        }
    }
    
    private func addElements(){
        contentView.addSubview(nftViewContent)

        nftViewContent.addSubview(nftImageView)
        nftViewContent.addSubview(likeButton)
        nftViewContent.addSubview(nftStackView)
        
        nftStackView.addArrangedSubview(nftStackLeft)
        nftStackView.addArrangedSubview(nftStackRight)
        
        nftStackLeft.addArrangedSubview(nameLabel)
        nftStackLeft.addArrangedSubview(ratingStackView)
        nftStackLeft.addArrangedSubview(authorView)
        
        authorView.addSubview(fromLabel)
        authorView.addSubview(authorLabel)
        
        nftStackRight.addArrangedSubview(priceLabel)
        nftStackRight.addArrangedSubview(priceValueLabel)
    }
    
    private func setupConstraints(){
        [likeButton, nftImageView, nftStackView,
         nftStackLeft, nameLabel, ratingStackView, authorView, fromLabel, authorLabel,
         nftStackRight, priceLabel, priceValueLabel, nftViewContent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftViewContent.heightAnchor.constraint(equalToConstant: 108),
            nftViewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftViewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            nftViewContent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: nftViewContent.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: nftViewContent.centerYAnchor),
            
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: nftViewContent.topAnchor, constant: 0),
            likeButton.leadingAnchor.constraint(equalTo: nftViewContent.leadingAnchor, constant: 68),
            
            nftStackLeft.heightAnchor.constraint(equalToConstant: 62),
            nftStackLeft.widthAnchor.constraint(equalToConstant: 95),
            nftStackRight.heightAnchor.constraint(equalToConstant: 42),
            nftStackRight.widthAnchor.constraint(equalToConstant: 90),
            
            nftStackView.topAnchor.constraint(equalTo: nftViewContent.topAnchor, constant: 23),
            nftStackView.leadingAnchor.constraint(equalTo: nftViewContent.leadingAnchor, constant: 128),
            nftStackView.trailingAnchor.constraint(equalTo: nftViewContent.trailingAnchor, constant: 0),
            nftStackView.bottomAnchor.constraint(equalTo: nftViewContent.bottomAnchor, constant: -23),
            
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            authorView.heightAnchor.constraint(equalToConstant: 20),
            authorView.widthAnchor.constraint(equalToConstant: 78),
            
            fromLabel.leadingAnchor.constraint(equalTo: authorView.leadingAnchor),
            fromLabel.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),
            
            authorLabel.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 5),
            authorLabel.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),
        ])
    }
}

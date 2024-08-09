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
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = .imageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "от"
        label.font = .caption1
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .caption2
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    private lazy var nftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var nftStackLeft: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var nftStackRight: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var authorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nftViewContent: UIView = UIView()
    
    private func setup() {
        setupView()
        
        nameLabel.text = model.name
        authorLabel.text = model.authorName
        priceValueLabel.text = "\(model.price) ETH"
        
        if let url = URL(string: model.image) {
            nftImageView.kf.setImage(with: url)
        }
        
        let likeImage = model.isLiked ? "profileImages/likeActive" : "profileImages/likeNoActive"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
        
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let activeStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypYellow, renderingMode: .alwaysOriginal)
        let inactiveStarImage = UIImage(systemName: "star.fill")?.withTintColor(.segmentInactive, renderingMode: .alwaysOriginal)
        
        for index in 1...Self.totalStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = index <= model.rating ? activeStarImage : inactiveStarImage
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.arrangedSubviews.forEach { ratingStackView.removeArrangedSubview($0) }
    }
    
    private func setupView() {
       
        backgroundColor = .white
        selectionStyle = .none
        
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
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        nftViewContent.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.nftViewContentHeight)
            make.leading.equalToSuperview().offset(CGFloat.horizontalPadding)
            make.trailing.equalToSuperview().offset(-CGFloat.horizontalTrailingPadding)
            make.centerY.equalToSuperview()
        }
        
        nftImageView.snp.makeConstraints { make in
            make.height.width.equalTo(CGFloat.nftImageViewSize)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.likeButtonSize)
            make.top.equalToSuperview()
            make.leading.equalTo(nftImageView.snp.trailing).offset(CGFloat.likeButtonLeadingOffset)
        }
        
        nftStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.stackViewTopOffset)
            make.leading.equalTo(nftImageView.snp.trailing).offset(CGFloat.stackViewLeadingOffset)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.stackViewBottomOffset)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.ratingStackViewHeight)
            make.width.equalTo(CGFloat.ratingStackViewWidth)
        }
        
        authorView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.authorViewHeight)
            make.width.equalTo(CGFloat.authorViewWidth)
        }
        
        fromLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(fromLabel.snp.trailing).offset(CGFloat.authorLabelLeadingOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func likeButtonTapped() {
        
    }
}

private extension CGFloat {
    static let nftViewContentHeight: CGFloat = 108
    static let nftImageViewSize: CGFloat = 108
    static let likeButtonSize: CGFloat = 40
    static let likeButtonLeadingOffset: CGFloat = 68
    static let stackViewTopOffset: CGFloat = 23
    static let stackViewLeadingOffset: CGFloat = 20
    static let stackViewBottomOffset: CGFloat = 23
    static let ratingStackViewHeight: CGFloat = 12
    static let ratingStackViewWidth: CGFloat = 68
    static let authorViewHeight: CGFloat = 20
    static let authorViewWidth: CGFloat = 78
    static let authorLabelLeadingOffset: CGFloat = 5
    static let horizontalPadding: CGFloat = 16
    static let horizontalTrailingPadding: CGFloat = 26
    static let imageViewCornerRadius: CGFloat = 12
}

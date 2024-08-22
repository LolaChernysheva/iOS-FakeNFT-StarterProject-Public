//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 10.08.2024.
//  
//

import UIKit
import Kingfisher

struct NFTCollectionViewCellModel {
    let image: String
    let name: String
    let authorName: String
    let price: String
    let rating: Int
    var isLiked: Bool
    
    var onLikeAction: (Bool) -> Void
    
    static let empty: NFTCollectionViewCellModel = NFTCollectionViewCellModel(image: "", name: "", authorName: "", price: "", rating: 0, isLiked: false, onLikeAction: { _ in })
}

final class NFTCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NFTCollectionViewCell"
    
    private static let totalStars = 5
    
    var model: NFTCollectionViewCellModel = .empty {
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
        label.textColor = .closeButton
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption1
        return label
    }()
    
    private lazy var nftStackView: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var nftViewContent: UIView = UIView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup () {
        
        nameLabel.text = model.name
        priceValueLabel.text = "\(model.price) ETH"
        
        if let url = URL(string: model.image) {
            nftImageView.kf.setImage(with: url)
        }
        
        likeButton.setImage(model.isLiked ? Asset.Images.favouritesDone : Asset.Images.favouritesNoActive, for: .normal)
        
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let starSize: CGFloat = 12
        let activeStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypYellow, renderingMode: .alwaysOriginal).resized(to: CGSize(width: starSize, height: starSize))
        let inactiveStarImage = UIImage(systemName: "star.fill")?.withTintColor(.segmentInactive, renderingMode: .alwaysOriginal).resized(to: CGSize(width: starSize, height: starSize))
        
        for index in 1...Self.totalStars {
            let starImageView = UIImageView(image: index <= model.rating ? activeStarImage : inactiveStarImage)
            starImageView.contentMode = .scaleAspectFit
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.snp.makeConstraints { make in
                make.width.height.equalTo(starSize)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupView() {
        contentView.addSubview(nftViewContent)
        
        nftViewContent.addSubview(nftImageView)
        nftViewContent.addSubview(likeButton)
        nftViewContent.addSubview(nftStackView)
        
        nftStackView.addArrangedSubview(nameLabel)
        nftStackView.addArrangedSubview(ratingStackView)
        nftStackView.addArrangedSubview(priceValueLabel)
        
    }
    
    private func setupConstraints() {
        nftViewContent.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nftImageView.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.nftImageSize)
            make.top.leading.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.likeButtonSize)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.likeButtonLeadingOffset)
        }
        
        nftStackView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.stackViewHeight)
            make.leading.equalTo(nftImageView.snp.trailing).offset(CGFloat.stackViewLeadingOffset)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.ratingStackViewSize)
        }
    }
    
    @objc
    private func likeButtonTapped() {
        model.onLikeAction(!model.isLiked)
    }
    
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

private extension CGFloat {
    static let nftImageSize: CGFloat = 80
    static let likeButtonSize: CGFloat = 30
    static let likeButtonLeadingOffset: CGFloat = 50
    static let stackViewHeight: CGFloat = 66
    static let stackViewLeadingOffset: CGFloat = 8
    static let ratingStackViewSize: CGSize = CGSize(width: 68, height: 12)
}

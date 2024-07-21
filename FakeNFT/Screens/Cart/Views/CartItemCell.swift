//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 17.07.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class CartItemCell: UITableViewCell {
    static let reuseIdentifier = "CartItemCell"

    let nftImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive

        return label
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        label.text = NSLocalizedString("Цена", comment: "")

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive

        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton.systemButton(
            with: Asset.Images.deleteFromCart ?? UIImage(),
            target: nil,
            action: nil
        )
        button.tintColor = UIColor.segmentActive

        return button
    }()

    private var infoVStack = UIStackView()

    // MARK: Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }

    func configure(with model: CartItemModel) {
        selectionStyle = .none

        [nftImageView, titleLabel, priceTitleLabel, priceLabel, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(nftImageView)
        contentView.addSubview(deleteButton)

        setupNftInfo(
            title: model.title,
            price: model.price,
            stars: model.starsCount
        )
        setupImage(model.image)

        setupDeleteButton()
    }

    private func setupImage(_ url: URL) {
        nftImageView.kf.setImage(with: url)
        nftImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.size.equalTo(nftImageView.snp.height)
        }
    }

    private func setupNftInfo(title: String, price: Double, stars: Int) {
        titleLabel.text = title
        priceLabel.text = "\(price) ETH"
        let ratingHStack = getRatingHStack(stars)

        let titleAndStarsVStack = UIStackView(
            arrangedSubviews: [titleLabel, ratingHStack]
        )
        let priceVStack = UIStackView(
            arrangedSubviews: [priceTitleLabel, priceLabel]
        )
        let infoVStack = UIStackView(
            arrangedSubviews: [titleAndStarsVStack, priceVStack]
        )

        [infoVStack, titleAndStarsVStack, priceVStack].forEach {
            $0.axis = .vertical
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alignment = .leading
        }
        titleAndStarsVStack.spacing = 4
        priceVStack.spacing = 2
        infoVStack.spacing = 12

        self.infoVStack = infoVStack
        contentView.addSubview(self.infoVStack)
        self.infoVStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.leading.equalTo(nftImageView.snp.trailing).offset(20)
        }

    }

    private func setupDeleteButton() {
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }

    private func getRatingHStack(_ rating: Int) -> UIStackView {
        var stars = [UIImageView]()
        for starIndex in 0..<5 {
            let fillStarImageView = UIImageView(image: Asset.Images.starDone)
            let emptyStarImageView = UIImageView(image: Asset.Images.starNoActive)
            stars.append(
                (rating - 1) >= starIndex ? fillStarImageView : emptyStarImageView
            )
        }

        let hStack = UIStackView(arrangedSubviews: stars)
        hStack.axis = .horizontal
        hStack.spacing = 2

        return hStack
    }
}

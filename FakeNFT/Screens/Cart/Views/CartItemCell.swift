//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 17.07.2024.
//

import UIKit
import SnapKit

final class CartItemCell: UITableViewCell {
    static let reuseIdentifier = "CartItemCell"

    private let nftImageView: UIImageView = {
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

        return button
    }()

    private var infoVStack = UIStackView()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    func configure(with model: CartItemModel) {
        [nftImageView, titleLabel, priceTitleLabel, priceLabel, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(nftImageView)
        contentView.addSubview(deleteButton)

        setupImage(model.image)
        setupNftInfo(
            title: model.title,
            price: model.price,
            stars: model.starsCount
        )
        setupDeleteButton()
    }

    private func setupImage(_ image: UIImage) {
        nftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(infoVStack.snp.leading)
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
        priceVStack.spacing = 12
        infoVStack.spacing = 2

        self.infoVStack = infoVStack
        self.infoVStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalTo(nftImageView.snp.trailing)
        }
    }

    private func setupDeleteButton() {
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(18.56)
        }
    }

    private func getRatingHStack(_ rating: Int) -> UIStackView {
        let fillStarImageView = UIImageView(image: Asset.Images.starDone)
        let emptyStarImageView = UIImageView(image: Asset.Images.starNoActive)

        var stars = [UIImageView]()
        for starIndex in 0..<5 {
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

//
//  CurrencyCollectionCell.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class CurrencyCollectionCell: UICollectionViewCell {
    // MARK: Properties

    static let reuseId = "CurrencyCollectionCell"

    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.segmentActive
        view.layer.cornerRadius = 6

        return view
    }()

    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6

        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive

        return label
    }()

    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption2
        label.textColor = UIColor.textGreen

        return label
    }()

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12
        backgroundColor = UIColor.segmentInactive

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    override func prepareForReuse() {
        fullNameLabel.text = nil
        shortNameLabel.text = nil
        currencyImageView.image = nil
    }

    func configure(with model: CurrencyModel) {
        currencyImageView.kf.setImage(with: model.image)
        fullNameLabel.text = model.title
        shortNameLabel.text = model.name
    }

    func select() {
        layer.borderColor = UIColor.segmentActive.cgColor
        layer.borderWidth = 1
    }

    func deselect() {
        layer.borderWidth = 0
    }

    private func setupSubviews() {
        [imageBackgroundView, currencyImageView, fullNameLabel, shortNameLabel].forEach {
            contentView.addSubview($0)
        }

        imageBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        currencyImageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackgroundView.snp.center)
            make.size.equalTo(31.5)
        }

        shortNameLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.leading.equalTo(currencyImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(5)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyImageView.snp.top)
            make.leading.equalTo(currencyImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(shortNameLabel.snp.top)
        }
    }
}

//
//  NFTCardCell.swift
//  FakeNFT
//
//  Created by Денис Николаев on 02.08.2024.
//

import UIKit

class NFTCardCell: UITableViewCell, ReuseIdentifying {

    // MARK: - UI Elements

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 28/255.0, green: 159/255.0, blue: 0/255.0, alpha: 1)
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with crypto: Crypto) {
        iconImageView.image = UIImage(named: crypto.iconName)
        titleLabel.text = "\(crypto.name) (\(crypto.symbol))"
        priceLabel.text = "$ \(crypto.price)"
        amountLabel.text = "0,\(crypto.amount) (\(crypto.symbol))"
    }

    // MARK: - UI Setup

    private func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(amountLabel)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.top.equalTo(contentView).offset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        amountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
        }
    }
}

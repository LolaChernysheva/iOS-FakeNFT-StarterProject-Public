//
//  PaymentPanelView.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 18.07.2024.
//

import UIKit

final class PaymentPanelView: UIView {
    // MARK: Properties

    private let countLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.caption1
        label.textColor = UIColor.segmentActive

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textGreen

        return label
    }()

    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle(
            NSLocalizedString("К оплате", comment: ""),
            for: .normal
        )
        button.setTitleColor(
            UIColor.background,
            for: .normal
        )
        button.backgroundColor = UIColor.segmentActive
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16

        return button
    }()

    // MARK: Init

    init() {
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    func set(count: Int, price: Double) {
        countLabel.text = "\(count) NFT"
        priceLabel.text = "\(String(format: "%.2f", price)) ETH"
    }

    private func configure() {
        backgroundColor = UIColor.segmentInactive
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 12

        setupViews()
    }

    private func setupViews() {
        addSubview(payButton)
        addSubview(countLabel)
        addSubview(priceLabel)

        payButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(priceLabel.snp.trailing).offset(24)
        }

        countLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(countLabel.snp.bottom).offset(2)
        }
    }
}

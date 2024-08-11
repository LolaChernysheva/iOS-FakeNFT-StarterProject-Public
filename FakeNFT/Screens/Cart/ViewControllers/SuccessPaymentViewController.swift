//
//  SuccessPaymentViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 30.07.2024.
//

import UIKit
import SnapKit

protocol SuccessPaymentViewControllerDelegate: AnyObject {
    func close()
}

final class SuccessPaymentViewController: UIViewController {
    // MARK: Properties
    private let delegate: SuccessPaymentViewControllerDelegate

    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString(
                "Вернуться в каталог",
                comment: ""
            ),
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

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.successPayment)

        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor.segmentActive
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString(
            "Успех! Оплата прошла, поздравляем с покупкой!",
            comment: ""
        )

        return label
    }()

    private var vStack: UIStackView?

    // MARK: Init

    init(delegate: SuccessPaymentViewControllerDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: Methods

    @objc private func closeScreen() {
        self.dismiss(animated: true)
        delegate.close()
    }

    private func configure() {
        view.backgroundColor = .background

        setupSubviews()
    }

    private func setupSubviews() {
        vStack = UIStackView(arrangedSubviews: [imageView, textLabel])
        guard let vStack else { return }
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 20

        paymentButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)

        [paymentButton, vStack].forEach {
            view.addSubview($0)
        }

        paymentButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(60)
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(278)
        }

        vStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(36)
        }
    }
}

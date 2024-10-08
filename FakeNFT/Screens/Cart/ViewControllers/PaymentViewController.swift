//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import UIKit
import SnapKit

protocol PaymentViewControllerProtocol: AnyObject,
                                        Loadable,
                                        ErrorPresentable {
    func setup(with data: CurrenciesScreenModel)
    func showPaymentSuccess()
}

final class PaymentViewController: UIViewController {
    // MARK: Properties

    private let presenter: PaymentPresenter
    private var currencies: [CurrencyModel] = []
    private var userAgreementLink: URL?
    private var selectedCurrencyId: String?

    private lazy var paymentPanel = FinalPaymentBottomPanel(
        onPayTap: startPayment,
        onLinkTap: openUserAgreement
    )

    private let progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive

        return progress
    }()

    private let currenciesCollection: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.backgroundColor = UIColor.background
        collection.showsHorizontalScrollIndicator = false
        collection.allowsMultipleSelection = false

        collection.register(
            CurrencyCollectionCell.self,
            forCellWithReuseIdentifier: CurrencyCollectionCell.reuseId
        )

        return collection
    }()

    // MARK: Init

    init(presenter: PaymentPresenter) {
        self.presenter = presenter

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

    private func openUserAgreement() {
        let userAgreementVC = UserAgreementViewController(link: userAgreementLink)
        userAgreementVC.modalPresentationStyle = .pageSheet

        present(userAgreementVC, animated: true)
    }

    private func startPayment() {
        presenter.pay(in: selectedCurrencyId)
    }

    private func configure() {
        view.backgroundColor = UIColor.background
        title = NSLocalizedString("Выберете способ оплаты", comment: "")
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.segmentActive
        ]

        currenciesCollection.dataSource = self
        currenciesCollection.delegate = self

        setupSubviews()
        presenter.setupData()
    }

    private func setupSubviews() {
        [currenciesCollection, paymentPanel, progressHud].forEach {
            view.addSubview($0)
        }

        currenciesCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        paymentPanel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-152)
        }

        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func getCell(
        _ collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> CurrencyCollectionCell? {
        guard let cell = collectionView.cellForItem(
            at: indexPath
        ) as? CurrencyCollectionCell else { return nil }

        return cell
    }
}

// MARK: CurrenciesViewControllerProtocol

extension PaymentViewController: PaymentViewControllerProtocol {
    func showError(title: String?, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let repeatAction = UIAlertAction(
            title: NSLocalizedString("Повторить", comment: ""),
            style: .default,
            handler: { [presenter, selectedCurrencyId] _ in
                presenter.pay(in: selectedCurrencyId)
            }
        )
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Отмена", comment: ""),
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true)
            }
        )

        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        alert.preferredAction = repeatAction

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

    func showProgressHud() {
        DispatchQueue.main.async { [weak self] in
            self?.progressHud.startAnimating()
        }
    }

    func hideProgressHud() {
        DispatchQueue.main.async { [weak self] in
            self?.progressHud.stopAnimating()
        }
    }

    func setup(with data: CurrenciesScreenModel) {
        userAgreementLink = data.userAgreementLink
        currencies = data.currencies
        DispatchQueue.main.async { [weak self] in
            self?.currenciesCollection.reloadData()
        }
    }

    func showPaymentSuccess() {
        let successPaymentVC = SuccessPaymentViewController(delegate: self)
        successPaymentVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(successPaymentVC, animated: true)
        }
    }
}

// MARK: SuccessPaymentViewControllerDelegate

extension PaymentViewController: SuccessPaymentViewControllerDelegate {
    func close() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionCell.reuseId,
            for: indexPath
        ) as? CurrencyCollectionCell else { return UICollectionViewCell() }

        cell.configure(with: currencies[indexPath.item])

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = getCell(collectionView, at: indexPath) else { return }

        selectedCurrencyId = cell.model?.id
        cell.select()
        paymentPanel.unlockButton()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = getCell(collectionView, at: indexPath) else {
            return
        }

        cell.deselect()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingWidth = CGFloat(39)
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / 2
        return CGSize(width: cellWidth, height: 46)
    }
}

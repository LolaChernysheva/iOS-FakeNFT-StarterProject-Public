//
//  CurrenciesViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import UIKit
import SnapKit

protocol CurrenciesViewControllerProtocol: AnyObject {
    func setup(with data: CurrenciesScreenModel)
}

final class CurrenciesViewController: UIViewController {
    // MARK: Properties

    private let presenter: CurrenciesPresenter
    private var currencies: [CurrencyModel] = []

    private let currenciesCollection: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.backgroundColor = UIColor.background
        collection.showsHorizontalScrollIndicator = false

        collection.register(
            CurrencyCollectionCell.self,
            forCellWithReuseIdentifier: CurrencyCollectionCell.reuseId
        )

        return collection
    }()

    // MARK: Init

    init(presenter: CurrenciesPresenter) {
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

    private func configure() {
        view.backgroundColor = UIColor.background
        title = NSLocalizedString("Выберете способ оплаты", comment: "")
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.segmentActive
        ]

//        self.navigationController?.navigationBar.backIndicatorImage = Asset.Images.backward
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = Asset.Images.backward
//        self.navigationController?.navigationBar.backItem?.title = ""
//        self.navigationItem.backBarButtonItem?.image = Asset.Images.backward
//        self.navigationItem.backButtonTitle = ""
        // navigationItem.backBarButtonItem?.tintColor = UIColor.segmentActive

        // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        currenciesCollection.dataSource = self
        currenciesCollection.delegate = self

        setupSubviews()
        presenter.setupData()
    }

    private func setupSubviews() {
        view.addSubview(currenciesCollection)

        currenciesCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CurrenciesViewController: CurrenciesViewControllerProtocol {
    func setup(with data: CurrenciesScreenModel) {
        currencies = data.currencies
        currenciesCollection.reloadData()
    }
}

extension CurrenciesViewController: UICollectionViewDataSource {
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
        ) as? CurrencyCollectionCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(with: currencies[indexPath.item])

        return cell
    }
}

extension CurrenciesViewController: UICollectionViewDelegateFlowLayout {
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

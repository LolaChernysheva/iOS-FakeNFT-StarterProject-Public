//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    func update(with data: CartScreenModel)
}

final class CartViewController: UIViewController {

    // MARK: Public Properties

    var presenter: CartPresenterProtocol?

    // MARK: Private Properties

    private var cards = [CartItemModel]()

    private lazy var paymentPanel = PaymentPanelView()

    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CartItemCell.self,
            forCellReuseIdentifier: CartItemCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        return tableView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        presenter?.setup()
    }

    // MARK: Private Methods

    private func configure() {
        view.backgroundColor = UIColor.background
        setupViews()
    }

    private func setupViews() {
        [nftTableView, paymentPanel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        setupPaymentPanel()
        setupNavBar()
        setupTableView()
    }

    private func setupPaymentPanel() {
        paymentPanel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(76)
        }
    }

    private func setupNavBar() {
        let filterButton = UIBarButtonItem(
            image: Asset.Images.sort,
            style: .plain,
            target: nil,
            action: nil
        )
        filterButton.tintColor = UIColor.segmentActive
        navigationItem.setRightBarButton(filterButton, animated: false)
    }

    private func setupTableView() {
        nftTableView.dataSource = self
        nftTableView.delegate = self

        nftTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

// MARK: CartViewProtocol

extension CartViewController: CartViewProtocol {
    func update(with data: CartScreenModel) {
        cards = data.items
        paymentPanel.configure(
            count: data.itemsCount,
            price: data.totalPrice
        )

        nftTableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.reuseIdentifier,
            for: indexPath
        )

        guard let cell = cell as? CartItemCell else {
            return UITableViewCell()
        }

        cell.configure(with: cards[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: UITableViewDelegate

extension CartViewController: UITableViewDelegate {

}

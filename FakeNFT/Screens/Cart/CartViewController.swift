//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import UIKit
import SnapKit

protocol CartViewProtocol: AnyObject {
    func update(with data: CartScreenModel)
    func showProgressHud()
    func hideProgressHud()
}

final class CartViewController: UIViewController {

    // MARK: Public Properties

    private let presenter: CartPresenterProtocol

    // MARK: Private Properties

    private var cards = [CartItemModel]()

    private lazy var paymentPanel = PaymentPanelView()
    private lazy var stubView = CartStubView(text: "Корзина пуста")

    private var progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive

        return progress
    }()

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

    // MARK: Init

    init(presenter: CartPresenterProtocol) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.setup()
    }

    // MARK: Private Methods

    private func configure() {
        view.backgroundColor = UIColor.background
        setupProgressHud()
    }

    private func setupViews() {
        [nftTableView, paymentPanel].forEach {
            view.addSubview($0)
        }

        setupPaymentPanel()
        setupNavBar()
        setupTableView()
    }

    private func setupProgressHud() {
        if stubView.isDescendant(of: view) {
            stubView.removeFromSuperview()
        }
        view.addSubview(progressHud)
        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupPaymentPanel() {
        paymentPanel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.equalTo(76)
        }
    }

    private func setupStubView() {
        view.addSubview(stubView)

        stubView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
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

    private func removeMainViews() {
        [nftTableView, paymentPanel].forEach {
            $0.removeFromSuperview()
        }
        navigationItem.setRightBarButton(nil, animated: false)
    }
}

// MARK: CartViewProtocol

extension CartViewController: CartViewProtocol {
    func update(with data: CartScreenModel) {
        cards = data.items
        if cards.isEmpty {
            if nftTableView.isDescendant(of: view) {
                removeMainViews()
            }
            setupStubView()
        } else {
            if !nftTableView.isDescendant(of: view) {
                setupViews()
                paymentPanel.configure(
                    count: data.itemsCount,
                    price: data.totalPrice
                )
                nftTableView.reloadData()
                stubView.removeFromSuperview()
            }
        }
    }

    func showProgressHud() {
        if stubView.isDescendant(of: view) {
            stubView.removeFromSuperview()
        }
        if nftTableView.isDescendant(of: view) {
            removeMainViews()
        }
        progressHud.startAnimating()
    }

    func hideProgressHud() {
        progressHud.stopAnimating()
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

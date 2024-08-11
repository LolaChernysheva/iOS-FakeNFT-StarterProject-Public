//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import UIKit
import SnapKit

protocol CartViewProtocol: AnyObject, Loadable {
    func update(with data: CartScreenModel)
    func updateAfterDelete(with data: CartScreenModel, deletedId: String)
}

final class CartViewController: UIViewController {
    // MARK: Properties

    private let presenter: CartPresenterProtocol
    private var cards = [CartItemModel]()

    private lazy var paymentPanel = PaymentPanelView { [weak self] in
        let currenciesVC = ModulesAssembly.currenciesScreenBuilder()
        currenciesVC.hidesBottomBarWhenPushed = true
        self?.presenter.needsReloadAfterReturning = true
        self?.navigationController?.pushViewController(currenciesVC, animated: true)
    }
    private lazy var stubView = CartStubView(text: "Корзина пуста")
    private lazy var deleteAlert = DeleteAlertView()

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
            target: self,
            action: #selector(showFilters)
        )

        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem?.tintColor = UIColor.segmentActive

        filterButton.tintColor = UIColor.segmentActive
        navigationItem.setRightBarButton(filterButton, animated: false)
    }

    private func setupTableView() {
        nftTableView.dataSource = self
        nftTableView.delegate = self

        nftTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(paymentPanel.snp.top)
        }
    }

    private func hideMainViews() {
        [nftTableView, paymentPanel].forEach {
            $0.isHidden = true
        }
        navigationItem.setRightBarButton(nil, animated: false)
    }

    private func showMainViews(with data: CartScreenModel) {
        if !nftTableView.isDescendant(of: view) {
            setupViews()
        }
        if nftTableView.isHidden {
            [nftTableView, paymentPanel].forEach {
                $0.isHidden = false
            }
            setupNavBar()

            nftTableView.reloadData()
            stubView.isHidden = true
        }
        paymentPanel.set(
            count: data.itemsCount,
            price: data.totalPrice
        )
    }

    @objc private func showFilters() {
        let actionSheet = UIAlertController(
            title: nil,
            message: NSLocalizedString("Сортировка", comment: ""),
            preferredStyle: .actionSheet
        )
        let titles = [
            NSLocalizedString("По цене", comment: ""),
            NSLocalizedString("По рейтингу", comment: ""),
            NSLocalizedString("По названию", comment: ""),
            NSLocalizedString("Закрыть", comment: "")
        ]
        let actions = [
            presenter.sortByPrice,
            presenter.sortByRating,
            presenter.sortByName,
            {}
        ]

        for index in 0..<4 {
            let action = UIAlertAction(
                title: titles[index],
                style: index == 3 ? .cancel : .default,
                handler: { [nftTableView] _ in
                    actions[index]()
                    if index != 3 {
                        nftTableView.reloadData()
                    }
                })
            actionSheet.addAction(action)
        }

        present(actionSheet, animated: true)
    }
}

// MARK: CartViewProtocol

extension CartViewController: CartViewProtocol {
    func update(with data: CartScreenModel) {
        cards = data.items
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if cards.isEmpty {
                if !stubView.isDescendant(of: view) {
                    setupStubView()
                }
                hideMainViews()
                stubView.isHidden = false
            } else {
                showMainViews(with: data)
                stubView.isHidden = true
            }
        }
    }

    func updateAfterDelete(with data: CartScreenModel, deletedId: String) {
        guard let row = (cards.firstIndex { $0.id == deletedId }) else { return }
        let lastDeletedIndexPath = IndexPath(row: row, section: 0)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            update(with: data)
            nftTableView.performBatchUpdates { [weak self] in
                self?.nftTableView.deleteRows(at: [lastDeletedIndexPath], with: .automatic)
            }
        }
    }

    func showProgressHud() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if !stubView.isHidden {
                stubView.isHidden = true
            } else {
                hideMainViews()
            }
            progressHud.startAnimating()
        }
    }

    func hideProgressHud() {
        DispatchQueue.main.async { [weak self] in
            self?.progressHud.stopAnimating()
        }
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
        let model = cards[indexPath.row]
        cell.configure(with: model) { [weak self] in
            guard let self else { return }
            deleteAlert.show(
                on: self,
                with: view.frame.height,
                image: model.image,
                onDelete: { [presenter] in
                    presenter.deleteNft(id: model.id)
                }
            )
            view.layoutSubviews()
        }

        return cell
    }
}

// MARK: UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

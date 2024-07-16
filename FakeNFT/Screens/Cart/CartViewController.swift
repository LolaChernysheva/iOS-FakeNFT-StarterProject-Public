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

    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()

        return tableView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: Private Methods

    private func setupViews() {
        setupPayPanel()
        setupNavBar()
        setupTableView()
    }

    private func setupPayPanel() {

    }

    private func setupNavBar() {

    }

    private func setupTableView() {

    }
}

// MARK: CartViewProtocol

extension CartViewController: CartViewProtocol {
    func update(with data: CartScreenModel) {

    }
}

//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    
}

final class CartViewController: UIViewController {
    
    // MARK: Public Properties
    
    var presenter: ProfilePresenterProtocol?
    
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
    
}

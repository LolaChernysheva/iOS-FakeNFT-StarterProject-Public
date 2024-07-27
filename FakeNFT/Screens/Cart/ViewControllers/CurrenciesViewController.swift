//
//  CurrenciesViewController.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import UIKit
import SnapKit

protocol CurrenciesViewControllerProtocol: AnyObject {
    func setup(with data: CurrencyScreenModel)
}

final class CurrenciesViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: CurrenciesPresenter
    
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
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        
    }
}

extension CurrenciesViewController: CurrenciesViewControllerProtocol {
    func setup(with data: CurrencyScreenModel) {
        
    }
}

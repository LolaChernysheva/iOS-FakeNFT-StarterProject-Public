//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import Foundation

protocol PaymentPresenterProtocol {
    func setupData()
}

final class PaymentPresenter {
    // MARK: Properties

    weak var view: PaymentViewControllerProtocol?
    private let currenciesService: PaymentServiceProtocol

    // MARK: Init

    init(currenciesService: PaymentServiceProtocol) {
        self.currenciesService = currenciesService
    }

    // MARK: Methods

    private func buildScreenModel(onResponse: @escaping (Result<CurrenciesScreenModel, Error>) -> Void) {
        currenciesService.getCurrencies { result in
            switch result {
            case .success(let currencies):
                onResponse(.success(CurrenciesScreenModel(currencies: currencies)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

// MARK: PaymentPresenterProtocol

extension PaymentPresenter: PaymentPresenterProtocol {
    func setupData() {
        view?.showProgressHud()
        buildScreenModel { [view] result in
            switch result {
            case .success(let model):
                view?.hideProgressHud()
                view?.setup(with: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pay(in currencyId: String) {
        
    }
}

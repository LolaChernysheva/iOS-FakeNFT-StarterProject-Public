//
//  CurrenciesPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import Foundation

protocol CurrenciesPresenterProtocol {
    func setupData()
}

final class CurrenciesPresenter {
    // MARK: Properties

    weak var view: CurrenciesViewControllerProtocol?
    private let currenciesService: CurrenciesServiceProtocol

    // MARK: Init

    init(currenciesService: CurrenciesServiceProtocol) {
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

// MARK: CurrenciesPresenterProtocol

extension CurrenciesPresenter: CurrenciesPresenterProtocol {
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
}

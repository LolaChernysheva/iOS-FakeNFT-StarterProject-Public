//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import Foundation

protocol PaymentPresenterProtocol {
    func setupData()
    func pay(in currencyId: String?)
}

final class PaymentPresenter {
    // MARK: Properties

    weak var view: PaymentViewControllerProtocol?
    private let paymentService: PaymentServiceProtocol

    // MARK: Init

    init(currenciesService: PaymentServiceProtocol) {
        self.paymentService = currenciesService
    }

    // MARK: Methods

    private func buildScreenModel(onResponse: @escaping (Result<CurrenciesScreenModel, Error>) -> Void) {
        paymentService.getCurrencies { result in
            switch result {
            case .success(let currencies):
                onResponse(.success(CurrenciesScreenModel(currencies: currencies)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    private func showError() {
        view?.showError(
            title: NSLocalizedString(
                "Не удалось произвести оплату",
                comment: ""
            ),
            message: nil
        )
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

    func pay(in currencyId: String?) {
        guard let currencyId else {
            showError()
            return
        }

        view?.showProgressHud()
        paymentService.pay(
            currencyId: currencyId
        ) { [view, showError] result in
            DispatchQueue.main.async {
                view?.hideProgressHud()
            }
            switch result {
            case .success(let payment):
                if payment.success {
                    view?.showPaymentSuccess()
                } else {
                    showError()
                }
            case .failure(let error):
                print(error)
                showError()
            }
        }
    }
}

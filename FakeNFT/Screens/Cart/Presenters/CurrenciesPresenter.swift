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
    weak var view: CurrenciesViewControllerProtocol?

    private func buildScreenModel() -> CurrenciesScreenModel {
        return CurrenciesScreenModel(currencies: [
            CurrencyModel(title: "Shiba_Inu", name: "SHIB", image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"), id: "0"),
            CurrencyModel(title: "Cardano", name: "ADA", image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png"), id: "1"),
            CurrencyModel(title: "Tether", name: "USDT", image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png"), id: "2")
        ])
    }
}

// MARK: CurrenciesPresenterProtocol

extension CurrenciesPresenter: CurrenciesPresenterProtocol {
    func setupData() {
        view?.setup(with: buildScreenModel())
    }
}

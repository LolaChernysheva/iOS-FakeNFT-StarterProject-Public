//
//  CurrenciesScreenModel.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 27.07.2024.
//

import Foundation

struct CurrenciesScreenModel {
    let currencies: [CurrencyModel]
    let userAgreementLink = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
}

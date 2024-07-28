//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 28.07.2024.
//

import Foundation

protocol CurrenciesServiceProtocol {
    func getCurrencies(
        onResponse: @escaping (Result<[CurrencyModel], Error>) -> Void
    )
}

final class CurrenciesService: CurrenciesServiceProtocol {
    private let networkClient: NetworkClient

    // MARK: Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }

    // MARK: Methods

    func getCurrencies(
        onResponse: @escaping (Result<[CurrencyModel], any Error>) -> Void
    ) {

    }
}

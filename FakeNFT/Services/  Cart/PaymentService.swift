//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 28.07.2024.
//

import Foundation

protocol PaymentServiceProtocol {
    func getCurrencies(
        onResponse: @escaping (Result<[CurrencyModel], Error>) -> Void
    )
}

final class PaymentService: PaymentServiceProtocol {
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
        let request = CurrenciesRequest()
        networkClient.send(
            request: request,
            type: [CurrencyModel].self) { result in
                switch result {
                case .success(let models):
                    onResponse(.success(models))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
    }
}

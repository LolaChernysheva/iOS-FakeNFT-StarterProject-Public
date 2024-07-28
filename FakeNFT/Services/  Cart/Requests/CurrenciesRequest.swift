//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 28.07.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
        self.token = RequestConstants.token
    }
}

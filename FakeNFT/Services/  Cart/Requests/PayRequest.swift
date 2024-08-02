//
//  PayRequest.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 30.07.2024.
//

import Foundation

struct PayRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init(currencyId: String) {
        self.endpoint = URL(
            string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)"
        )
        self.token = RequestConstants.token
    }
}

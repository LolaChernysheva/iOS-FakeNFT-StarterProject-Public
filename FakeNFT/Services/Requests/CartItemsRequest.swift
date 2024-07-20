//
//  CartItemsRequest.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

struct CartItemsRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        self.token = RequestConstants.token
    }
}

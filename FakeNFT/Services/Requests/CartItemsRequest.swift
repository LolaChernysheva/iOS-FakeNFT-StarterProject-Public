//
//  CartItemsRequest.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

struct CartItemsRequest: NetworkRequest {
    var endpoint = URL(string: "\(RequestConstants.baseURL)/orders/1")
    var token = RequestConstants.token
}

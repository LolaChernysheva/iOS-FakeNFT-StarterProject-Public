//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

final class CartService {
    let networkClient: NetworkClient = DefaultNetworkClient()

    func getCartItems() {
        let request = CartItemsRequest()
        networkClient.send(
            request: request,
            type: CartItemDTO.self
        ) { result in
                switch result {
                case .success(let item):
                    break
                case .failure(let error):
                    break
                }
        }
    }
}

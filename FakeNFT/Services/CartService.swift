//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

final class CartService {
    let networkClient: NetworkClient = DefaultNetworkClient()

    func getCartItems(onResponse: @escaping (Result<CartItemsDTO, Error>) -> Void) {
        let request = CartItemsRequest()
        networkClient.send(
            request: request,
            type: CartItemsDTO.self
        ) { result in
                switch result {
                case .success(let items):
                    onResponse(.success(items))
                case .failure(let error):
                    onResponse(.failure(error))
                }
        }
    }
}

//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

final class CartService {
    let networkClient: NetworkClient = DefaultNetworkClient()

    func getCartItems(onResponse: @escaping (Result<[CartItemModel], Error>) -> Void) {
        let request = CartItemsRequest()
        networkClient.send(
            request: request,
            type: CartItemsDTO.self
        ) { result in
            switch result {
            case .success(let response):
                var items = [CartItemModel]()
                response.nfts.forEach { [weak self] id in
                    self?.getNft(by: id) { item in
                        guard let item else { return }
                        items.append(item)
                    }
                }
                onResponse(.success(items))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    private func getNft(by id: String, onResponse: @escaping (CartItemModel?) -> Void) {
        
    }

    func updateCart(_ items: [String], onResponse: @escaping (Result<Data, Error>) -> Void) {
        let request = UpdateCartItemsRequest(dto: ["1"])
        networkClient.send(request: request) { result in
            switch result {
            case .success(let data):
                onResponse(.success(data))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

}

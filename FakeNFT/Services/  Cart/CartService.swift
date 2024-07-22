//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

final class CartService {
    let networkClient: NetworkClient = DefaultNetworkClient()

    func getCartItems(
        onResponse: @escaping (Result<[CartItemModel], Error>) -> Void
    ) {
        let request = CartItemsRequest()
        networkClient.send(
            request: request,
            type: CartItemsDTO.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                let dispatchGroup = DispatchGroup()
                var cartItems: [CartItemModel] = []
                var errors: [Error] = []
                let testIds = [
                    "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
                    "1464520d-1659-4055-8a79-4593b9569e48",
                    "b3907b86-37c4-4e15-95bc-7f8147a9a660"
                ]

                for id in testIds {
                    dispatchGroup.enter()
                    self?.getNftCartModel(by: id) { cartItem in
                        if let cartItem = cartItem {
                            cartItems.append(cartItem)
                        } else {
                            errors.append(NSError(
                                domain: "fakenftapi",
                                code: -1,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Failed to get cart item for id \(id)"
                                ]))
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    if !errors.isEmpty {
                        onResponse(.failure(errors.first!))
                    } else {
                        onResponse(.success(cartItems))
                    }
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    func getNftCartModel(by id: String, onResponse: @escaping (CartItemModel?) -> Void) {
        let request = GetNftRequest(id: id)
        networkClient.send(
            request: request,
            type: NftDTO.self
        ) { result in
            switch result {
            case .success(let nft):
                onResponse(
                    CartItemModel(
                        id: nft.id,
                        title: nft.name,
                        image: nft.images[0],
                        price: nft.price,
                        starsCount: nft.rating
                    )
                )
            default:
                onResponse(nil)
            }
        }
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

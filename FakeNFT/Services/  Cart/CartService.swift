//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

protocol CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<([CartItemModel], [String]), Error>) -> Void
    )
    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<[String], Error>) -> Void
    )
}

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient

    // MARK: Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }

    // MARK: Methods

    func getCartItems(
        onResponse: @escaping (Result<([CartItemModel], [String]), Error>) -> Void
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

                for id in response.nfts {
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
                        onResponse(.success((cartItems, response.nfts)))
                    }
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<[String], Error>) -> Void
    ) {
        let request = UpdateCartItemsRequest(ids: items)
        networkClient.send(request: request, type: CartItemsDTO.self) { result in
            switch result {
            case .success(let data):
                onResponse(.success(data.nfts))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    private func getNftCartModel(by id: String, onResponse: @escaping (CartItemModel?) -> Void) {
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
}

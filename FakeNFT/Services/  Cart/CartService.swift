//
//  CartService.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

final class CartService {
    let networkClient: NetworkClient = DefaultNetworkClient()
    private var items = [CartItemModel]()

    func getCartItems(onResponse: @escaping (Result<[CartItemModel], Error>) -> Void) {
        getCartItemsDTO { result in
            switch result {
            case .success(let identifiers):
                identifiers.forEach { [weak self] id in
                    self?.getNftCartModel(by: id) { [weak self] item in
                        guard let item, let self else { return }
                        items.append(item)
                        if items.count == identifiers.count {
                            onResponse(.success(items))
                        }
                    }
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    private func getCartItemsDTO(
        onResponse: @escaping (Result<[String], Error>) -> Void
    ) {
        let request = CartItemsRequest()
        networkClient.send(
            request: request,
            type: CartItemsDTO.self
        ) { result in
            switch result {
            case .success(let response):
                onResponse(.success(response.nfts))
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

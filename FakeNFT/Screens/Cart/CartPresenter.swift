//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func setup()
}

final class CartPresenter {
    weak var view: CartViewProtocol?
    private let cartService: CartService

    init(view: CartViewProtocol?, cartService: CartService) {
        self.view = view
        self.cartService = cartService
    }

    // MARK: Private Methods

    private func buildScreenModel(
        onResponse: @escaping (Result<CartScreenModel, Error>) -> Void
    ) {
        cartService.getCartItems { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.cartService.getCartItems { result in
                    switch result {
                    case .success(let items):
                        onResponse(.success(CartScreenModel(items: items)))
                    case .failure(let error):
                        onResponse(.failure(error))
                    }
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    func setup() {
        buildScreenModel { [weak self] result in
            switch result {
            case .success(let model):
                self?.view?.update(with: model)
            case .failure(let error):
                print(error)
            }
        }
    }
}

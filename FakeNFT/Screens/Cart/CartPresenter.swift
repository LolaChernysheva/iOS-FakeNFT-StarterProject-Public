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

    init(cartService: CartService) {
        self.cartService = cartService
    }

    // MARK: Private Methods

    private func buildScreenModel(
        onResponse: @escaping (Result<CartScreenModel, Error>) -> Void
    ) {
        cartService.getCartItems { result in
            switch result {
            case .success(let items):
                onResponse(.success(CartScreenModel(items: items)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    func setup() {
        view?.showProgressHud()
        buildScreenModel { [weak self] result in
            switch result {
            case .success(let model):
                self?.view?.update(with: model)
            case .failure(let error):
                print(error)
            }
            self?.view?.hideProgressHud()
        }
    }
}

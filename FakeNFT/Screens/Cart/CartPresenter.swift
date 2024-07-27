//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject {
    func setup()
    func deleteNft(id: String)
}

final class CartPresenter {
    weak var view: CartViewProtocol?
    private let cartService: CartServiceProtocol
    private var ids: [String] = []
    private var items = [CartItemModel]()

    init(cartService: CartService) {
        self.cartService = cartService
    }

    // MARK: Private Methods

    private func buildScreenModel(
        onResponse: @escaping (Result<CartScreenModel, Error>) -> Void
    ) {
        cartService.getCartItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.ids = items.1
                self?.items = items.0
                onResponse(.success(CartScreenModel(items: items.0)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    func deleteNft(id: String) {
        ids.removeAll { $0 == id }
        items.removeAll { $0.id == id }
        cartService.updateCart(ids) { [weak self] result in
            switch result {
            case .success(let ids):
                guard let self else { return }
                self.ids = ids
                self.view?.updateAfterDelete(with: CartScreenModel(items: self.items), deletedId: id)
            case .failure(let error):
                print(error)
            }
        }
    }

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

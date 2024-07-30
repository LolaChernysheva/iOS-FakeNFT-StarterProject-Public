//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import Foundation

protocol CartPresenterProtocol: AnyObject, Filterable {
    var needsReloadAfterReturning: Bool { get set }
    func setup()
    func deleteNft(id: String)
}

final class CartPresenter {
    // MARK: Public Properties

    weak var view: CartViewProtocol?
    var needsReloadAfterReturning = true

    // MARK: Private Properties

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
    func sortByName() {
        items = items.sorted { lhs, rhs in
            lhs.title < rhs.title
        }
        view?.update(with: CartScreenModel(items: items))
    }

    func sortByPrice() {
        items = items.sorted { lhs, rhs in
            lhs.price > rhs.price
        }
        view?.update(with: CartScreenModel(items: items))
    }

    func sortByRating() {
        items = items.sorted { lhs, rhs in
            lhs.starsCount > rhs.starsCount
        }
        view?.update(with: CartScreenModel(items: items))
    }

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
        if !needsReloadAfterReturning {
            needsReloadAfterReturning = true
            return
        }
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

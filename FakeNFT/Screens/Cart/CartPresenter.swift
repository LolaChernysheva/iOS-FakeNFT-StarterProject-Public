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

    init(view: CartViewProtocol?) {
        self.view = view
    }

    // MARK: Private Methods

    private func buildScreenModel() -> CartScreenModel {
        CartScreenModel(
            items: buildCartItems()
        )
    }

    private func buildCartItems() -> [CartItemModel] {
        let items = Array(repeating: CartItemModel.mock, count: 3)
        return items
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    func setup() {
        view?.update(with: buildScreenModel())
    }
}

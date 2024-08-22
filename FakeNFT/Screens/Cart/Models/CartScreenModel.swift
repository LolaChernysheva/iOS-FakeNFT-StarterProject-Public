//
//  CartScreenModel.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import Foundation

struct CartScreenModel {
    let items: [CartItemModel]
    let itemsCount: Int

    var totalPrice: Double {
        var price: Double = 0
        items.forEach {
            price += $0.price
        }
        return price
    }

    init(items: [CartItemModel]) {
        self.items = items
        self.itemsCount = items.count
    }
}

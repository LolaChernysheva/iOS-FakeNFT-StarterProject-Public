//
//  CartItemModel.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 16.07.2024.
//

import UIKit

struct CartItemModel {
    let id: String
    let title: String
    let image: UIImage
    let price: Double
    let starsCount: Int
    
    static let mock = CartItemModel(
        id: "1",
        title: "Test",
        image: UIImage(systemName: "square.fill") ?? UIImage(),
        price: 1.79,
        starsCount: 3
    )
}

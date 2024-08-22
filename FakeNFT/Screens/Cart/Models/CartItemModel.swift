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
    let image: URL
    let price: Double
    let starsCount: Int

    static let mock = CartItemModel(
        id: "1",
        title: "Test",
        image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
        price: 1.79,
        starsCount: 3
    )
}

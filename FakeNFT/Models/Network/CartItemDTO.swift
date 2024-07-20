//
//  CartItemDTO.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 20.07.2024.
//

import Foundation

struct CartItemDTO: Codable {
    let id: String
    let nfts: [String]
}

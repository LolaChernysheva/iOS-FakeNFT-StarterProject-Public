//
//  NftResponceModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation

struct NftResponceModel: Codable {
    var createdAt: String
    var name: String
    var images: [String]
    var rating: Int
    var description: String
    var price: CGFloat
    var author: String
    var id: String
}

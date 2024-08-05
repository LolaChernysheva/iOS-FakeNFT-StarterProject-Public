//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct OrderModel: Codable {
  let nfts: [String]?
  let id: String
<<<<<<< HEAD

=======
  
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
  func update(newNfts: [String]? = nil) -> OrderModel {
    .init(
      nfts: newNfts ?? nfts,
      id: id
    )
  }
}

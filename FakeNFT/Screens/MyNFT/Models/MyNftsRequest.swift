//
//  MyNftsRequest.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation

struct MyNftsRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

//
//  GetNftRequest.swift
//  FakeNFT
//
//  Created by Александр Плешаков on 21.07.2024.
//

import Foundation

struct GetNftRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init(id: String) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
        self.token = RequestConstants.token
    }
}

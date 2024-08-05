//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
<<<<<<< HEAD

=======
   
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    let order: OrderModel
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        var components: [URLQueryItem] = []
<<<<<<< HEAD

=======
        
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
        if let nfts = order.nfts {
            for nft in nfts {
                components.append(URLQueryItem(name: "nfts", value: nft))
            }
        }
<<<<<<< HEAD

=======
        
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
        urlComponents?.queryItems = components
        return urlComponents?.url
    }
    var httpMethod: HttpMethod {
        return .put
    }
<<<<<<< HEAD

    var isUrlEncoded: Bool {
        return true
    }

=======
    
    var isUrlEncoded: Bool {
        return true
    }
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    var dto: Encodable?
}

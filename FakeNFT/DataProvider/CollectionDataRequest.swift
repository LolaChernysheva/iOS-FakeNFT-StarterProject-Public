//
//  CollectionDataRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct CollectionDataRequest: NetworkRequest {
    var endpoint: URL?
<<<<<<< HEAD

=======
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    init(id: String) {
        guard let endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)") else { return }
        self.endpoint = endpoint
    }
}

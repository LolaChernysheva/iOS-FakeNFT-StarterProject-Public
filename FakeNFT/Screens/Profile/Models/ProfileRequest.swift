//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 05.08.2024.
//  
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let id: String
    let method: HttpMethod
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    
    var headers: [String : String]? {
        ["X-Practicum-Mobile-Token": "edfc7835-684c-4eaf-a7b3-26ecea542ca3"]
    }
}

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
    let httpMethod: HttpMethod
    let dto: Encodable?
    
    var token: String? {
        RequestConstants.token
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}

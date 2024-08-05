//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

<<<<<<< HEAD
import Foundation

struct ProfileUpdateRequest: NetworkRequest {

  let profileModel: ProfileModel

  var endpoint: URL? {
    var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    var components: [URLQueryItem] = []

=======

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
  
  let profileModel: ProfileModel
  
  var endpoint: URL? {
    var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    var components: [URLQueryItem] = []
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    if let likes = profileModel.likes {
      for like in likes {
        components.append(URLQueryItem(name: "likes", value: like))
      }
    }
<<<<<<< HEAD

=======
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    if let nfts = profileModel.nfts {
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

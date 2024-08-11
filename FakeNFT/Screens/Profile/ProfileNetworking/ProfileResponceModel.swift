//
//  ProfileResponceModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 02.08.2024.
//  
//

import Foundation

struct ProfileResponseModel: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    var id: String
}

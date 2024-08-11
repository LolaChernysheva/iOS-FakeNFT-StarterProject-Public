//
//  UpdateProfileRequestModel.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 07.08.2024.
//  
//

import Foundation

struct UpdateProfileRequestModel: Encodable {
    let name: String
    let description: String
    let website: String
    let likes: [String]
}

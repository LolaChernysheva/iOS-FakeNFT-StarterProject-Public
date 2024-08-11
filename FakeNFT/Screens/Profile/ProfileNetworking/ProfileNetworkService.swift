//
//  ProfileNetworkService.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 05.08.2024.
//  
//

import Foundation

typealias ProfileCompletion = (Result<ProfileResponseModel, Error>) -> Void

protocol ProfileNetworkServiceProtocol: AnyObject {
    func loadProfile(profileId: String, completion: @escaping ProfileCompletion)
    func updateProfile(profile: Profile, completion: @escaping ProfileCompletion)
}

final class ProfileNetworkService: ProfileNetworkServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(profileId: String, completion: @escaping ProfileCompletion) {
        let request = ProfileRequest(id: profileId, httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: ProfileResponseModel.self) { result in
            switch result {
            case let .success(profile):
                completion(.success(profile))
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func updateProfile(profile: Profile, completion: @escaping ProfileCompletion) {
        
        let request = UpdateProfileRequest(
            profile: UpdateProfileRequestModel(
                name: profile.name,
                description: profile.description,
                website: profile.website,
                likes: profile.likes)
        )
        
        networkClient.send(request: request, type: ProfileResponseModel.self) { result in
            switch result {
            case let .success(profile):
                completion(.success(profile))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private struct Constants {
    static let profileId: String = "1"
}

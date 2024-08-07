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
}

final class ProfileNetworkService: ProfileNetworkServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(profileId: String, completion: @escaping ProfileCompletion) {
        let request = ProfileRequest(id: profileId, method: .get)
        networkClient.send(request: request, type: ProfileResponseModel.self) { [weak self] result in
            switch result {
            case let .success(profile):
                completion(.success(profile))
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}

private struct Constants {
    static let profileId: String = "1"
}

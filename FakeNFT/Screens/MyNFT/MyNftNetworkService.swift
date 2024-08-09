//
//  MyNftNetworkService.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation

protocol MyNftNetworkServiceProtocol: AnyObject {
    func fetchNft(id: String, completion: @escaping (Result<NftResponceModel, Error>) -> Void)
}

final class MyNftNetworkService: MyNftNetworkServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNft(id: String, completion: @escaping (Result<NftResponceModel, Error>) -> Void) {
        let request = MyNftsRequest(id: id)
        networkClient.send(request: request, type: NftResponceModel.self) { result in
            switch result {
            case let .success(nft):
                completion(.success(nft))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

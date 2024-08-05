//
//  CatalogDataProvider.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation

// MARK: - Protocol

protocol CatalogDataProviderProtocol: AnyObject {
    func fetchNFTCollection(
        completion: @escaping (
            [NFTCollection]
        ) -> Void
    )
    func sortNFTCollections(
        by: NFTCollectionsSort
    )
    func getCollectionNFT() -> [NFTCollection]
}

// MARK: - Final Class

final class CatalogDataProvider: CatalogDataProviderProtocol {
    private var collectionNFT: [NFTCollection] = []
<<<<<<< HEAD

    let networkClient: DefaultNetworkClient

=======
    
    let networkClient: DefaultNetworkClient
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    init(
        networkClient: DefaultNetworkClient
    ) {
        self.networkClient = networkClient
    }
<<<<<<< HEAD

    func getCollectionNFT() -> [NFTCollection] {
        return collectionNFT
    }

=======
    
    func getCollectionNFT() -> [NFTCollection] {
        return collectionNFT
    }
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    func fetchNFTCollection(
        completion: @escaping (
            [NFTCollection]
        ) -> Void
    ) {
        networkClient.send(
            request: NFTTableViewRequest(),
            type: [NFTCollection].self
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(
                let nft
            ):
                self.collectionNFT = nft
                completion(
                    nft
                )
<<<<<<< HEAD
            case .failure:
=======
            case .failure(
                _
            ):
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
                break
            }
        }
    }
<<<<<<< HEAD

=======
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    func sortNFTCollections(
        by: NFTCollectionsSort
    ) {
        switch by {
        case .name:
            collectionNFT.sort {
                $0.name < $1.name
            }
        case .nftCount:
            collectionNFT.sort {
                $0.nfts.count > $1.nfts.count
            }
        }
    }
}

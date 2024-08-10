//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 10.08.2024.
//  
//

import Foundation
import Dispatch

protocol FavoriteNFTPresenterProtocol: AnyObject {
    func setup()
}

final class FavoriteNFTPresenter {
    
    typealias Cell = FavoriteNFTScreenModel.CollectionData.Cell
    
    private weak var view: FavoriteNFTViewProtocol?
    private var service: MyNftNetworkServiceProtocol?
    
    private var profile: Profile?
    
    private var likedNfts: [NftModel] = []
    
    private var likedNFTIds: [String] = []
    
    private(set) var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateLoadingState(isLoading: self.isLoading)
            }
        }
    }
    
    init(
        view: FavoriteNFTViewProtocol?,
        service: MyNftNetworkServiceProtocol,
        profile: Profile
    ) {
        self.view = view
        self.profile = profile
        self.likedNFTIds = profile.likes
        self.service = service
        loadNfts()
    }
    
    private func buildScreenModel() -> FavoriteNFTScreenModel {
        let cells: [Cell] = likedNfts.map { nft in
                .nftCell(NFTCollectionViewCellModel(
                    image: nft.imageString,
                    name: nft.name,
                    authorName: nft.authorName,
                    price: String("\(nft.price)"),
                    rating: nft.rating,
                    isLiked: nft.isLiked,
                    onLikeAction: { isLiked in
                        //TODO: -
                    })
                )
        }
        return FavoriteNFTScreenModel(
            title: "Избранные NFT",
            collectionData: FavoriteNFTScreenModel.CollectionData(sections: [
                .simple(cells: cells)
            ])
        )
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadData: reloadData)
    }
    
    private func loadNfts() {
        isLoading = true
        let group = DispatchGroup()
        
        likedNFTIds.forEach { id in
            group.enter()
            
            service?.fetchNft(id: id) { [weak self] result in
                guard let self else { return }
                defer { group.leave() }
                switch result {
                case let .success(nft):
                    self.likedNfts.append(NftModel(
                        name: nft.name,
                        rating: nft.rating,
                        authorName: nft.author,
                        price: nft.price,
                        imageString: nft.images.first ?? "",
                        id: nft.id,
                        isLiked: true)
                    )
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) { [ weak self ] in
            guard let self else { return }
            self.isLoading = false
            self.render()
        }
    }
}

extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {
    func setup() {
        render()
    }
}

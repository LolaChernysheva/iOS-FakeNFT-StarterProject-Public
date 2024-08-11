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
    var likedNFTIds: [String] { get }
    func setup()
}

final class FavoriteNFTPresenter {
    
    typealias Cell = FavoriteNFTScreenModel.CollectionData.Cell
    
    private weak var view: FavoriteNFTViewProtocol?
    private var service: MyNftNetworkServiceProtocol?
    private var profileService: ProfileNetworkServiceProtocol?
    
    private var profile: Profile?
    
    private var likedNfts: [NftModel] = []
    
    private(set) var likedNFTIds: [String] = []
    
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
        profileService: ProfileNetworkServiceProtocol,
        profile: Profile
    ) {
        self.view = view
        self.profile = profile
        self.likedNFTIds = profile.likes
        self.service = service
        self.profileService = profileService
        loadNfts()
    }
    
    private func buildScreenModel() -> FavoriteNFTScreenModel {
        let cells: [Cell] = likedNfts.map { nft in
            .nftCell(
                NFTCollectionViewCellModel(
                    image: nft.imageString,
                    name: nft.name,
                    authorName: nft.authorName,
                    price: String("\(nft.price)"),
                    rating: nft.rating,
                    isLiked: nft.isLiked,
                    onLikeAction: { [weak self] isLiked in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            self.likedNFTIds.removeAll { $0 == nft.id }
                            self.likedNfts.removeAll { $0.id == nft.id }
                            self.profile?.likes = self.likedNFTIds
                            self.updateProfile()
                        }
                    }
                )
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
                    DispatchQueue.main.async {
                        self.likedNfts.append(NftModel(
                            name: nft.name,
                            rating: nft.rating,
                            authorName: nft.author,
                            price: nft.price,
                            imageString: nft.images.first ?? "",
                            id: nft.id,
                            isLiked: true)
                        )
                    }
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
    
    private func updateProfile() {
        guard let profile = profile else { return }
        profileService?.updateProfile(profile: Profile(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: likedNFTIds,
            id: profile.id)
        ) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(profile):
                    self.render()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {
    func setup() {
        render()
    }
}

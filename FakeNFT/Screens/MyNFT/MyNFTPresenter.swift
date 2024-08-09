//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import Foundation
import Dispatch

protocol MyNFTPresenterProtocol: AnyObject {
    var nftIds: [String] { get }
    func setup()
    func sortByPrice()
    func sortByRating()
    func sortByName() 
}

final class MyNFTPresenter {
    
    private weak var view: MyNFTViewProtocol?
    private var service: MyNftNetworkServiceProtocol?
    private var profileService: ProfileNetworkServiceProtocol?
    
    private var profile: Profile?
    private (set) var nftIds: [String]
    
    private var nfts: [NftModel] = [] {
        didSet {
            render(reloadData: true)
        }
    }
    
    private var likedNftsIds: [String] = [] {
        didSet {
            updateNftModels()
            render(reloadData: true)
        }
    }
    
    private(set) var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateLoadingState(isLoading: self.isLoading)
            }
        }
    }
    
    init(view: MyNFTViewProtocol?, networkService: MyNftNetworkServiceProtocol?, profileService: ProfileNetworkServiceProtocol?, profile: Profile) {
        self.view = view
        self.service = networkService
        self.profileService = profileService
        self.profile = profile
        self.nftIds = profile.nfts
        self.likedNftsIds = profile.likes
        loadNfts()
    }
    
    private func buildScreenModel() -> MyNFTScreenModel {
        MyNFTScreenModel(
            title: NSLocalizedString("Мои NFT", comment: ""),
            tableData: .init(sections: buildNftsSection())
        )
    }
    
    private func buildNftsSection() -> [MyNFTScreenModel.TableData.Section] {
        let cells: [MyNFTScreenModel.TableData.Cell] = nfts.map { nft in
            .nftCell(NFTTableViewCellModel(
                image: nft.imageString,
                name: nft.name,
                authorName: nft.authorName,
                price: String("\(nft.price)"),
                rating: nft.rating,
                isLiked: nft.isLiked,
                onLikeAction: { [weak self] isLiked in
                    guard let self else { return }
                    if isLiked {
                        if !self.likedNftsIds.contains(nft.id) {
                            self.likedNftsIds.append(nft.id)
                        }
                    } else {
                        self.likedNftsIds.removeAll { $0 == nft.id }
                    }
                    self.profile?.likes = self.likedNftsIds
                    self.updateProfile()
                }
            ))
        }
        return [.simple(cells: cells)]
    }
    
    private func updateNftModels() {
        nfts = nfts.map { nft in
            var updatedNft = nft
            updatedNft.isLiked = likedNftsIds.contains(nft.id)
            return updatedNft
        }
    }
    
    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadData: reloadData)
    }
    
    private func loadNfts() {
        isLoading = true
        let group = DispatchGroup()
        
        nftIds.forEach { id in
            group.enter()
            
            service?.fetchNft(id: id, completion: { [weak self] result in
                guard let self else { return }
                defer { group.leave() }
                
                switch result {
                case let .success(nft):
                    self.nfts.append(
                        NftModel(
                            name: nft.name,
                            rating: nft.rating,
                            authorName: nft.author,
                            price: nft.price,
                            imageString: nft.images.first ?? "",
                            id: nft.id,
                            isLiked: self.likedNftsIds.contains(nft.id))
                    )
                case let .failure(error):
                    print(error.localizedDescription)
                }
            })
        }
        
        group.notify(queue: .main) { [weak self] in
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
            likes: likedNftsIds,
            id: profile.id)
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(profile):
                self.render()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MyNFTPresenter: MyNFTPresenterProtocol {
    func setup() {
        render()
    }
    
    func sortByPrice() {
        nfts.sort { $0.price < $1.price }
        render()
    }
    
    func sortByRating() {
        nfts.sort { $0.rating > $1.rating }
        render()
    }
    
    func sortByName() {
        nfts.sort { $0.name < $1.name }
        render()
    }
}

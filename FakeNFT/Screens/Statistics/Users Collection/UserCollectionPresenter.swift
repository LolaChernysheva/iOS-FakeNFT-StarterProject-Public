//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit
import ProgressHUD

protocol UserCollectionPresenterProtocol: AnyObject {
    func getCollectionList() -> [Nft]
    func setUser(with newUser: NFTUser)
    func loadData(completion: @escaping () -> Void)
    func onlikeButtonTapped(nft: Nft)
    func addToCartButtonTapped(nft: Nft)
    
}

final class UserCollectionPresenter {
    private var userCollectionNetworkService: UserCollectionNetworkServiceProtocol
    private var collectionDataProvider : CollectionDataProvider
    private var selectedUser: NFTUser?
    private var collectionList: [Nft] = []
    
    weak var view: UserCollectionViewProtocol?
    
    init(selectedUser: NFTUser) {
        self.selectedUser = selectedUser
        self.userCollectionNetworkService = UserCollectionNetworkService(networkClient: DefaultNetworkClient())
        self.collectionDataProvider = CollectionDataProvider(networkClient: DefaultNetworkClient())
    }
    
    init() {
        self.selectedUser = NFTUser(name: "", avatar: "", description: "", website: "", nfts: [], rating: "", id: "")
        self.userCollectionNetworkService = UserCollectionNetworkService(networkClient: DefaultNetworkClient())
        self.collectionDataProvider = CollectionDataProvider(networkClient: DefaultNetworkClient())
    }
    
    func loadData(completion: @escaping () -> Void) {
        collectionList = []
        guard let selectedUser = selectedUser else { return }
        userCollectionNetworkService.fetchNFTCollectionFrom(user: selectedUser) { [weak self] in
            guard let self = self else { return }
            self.collectionList = self.userCollectionNetworkService.getNFTCollection()
          
                if !self.collectionList.isEmpty {
                    self.view?.updateCollectionList(with: self.collectionList)
                }
                self.view?.hideLoading()
                completion()
        }
    }
}

// MARK: UsersCollectionPresenterProtocol

extension UserCollectionPresenter: UserCollectionPresenterProtocol {
    func onlikeButtonTapped(nft: Nft) {
        ProgressHUD.show()
        collectionDataProvider.getUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                var updatedLikes = profile.likes ?? []
                if updatedLikes.contains(nft.id) {
                    updatedLikes.removeAll { $0 == nft.id }
                } else {
                    updatedLikes.append(nft.id)
                }
                let updatedProfile = profile.update(newLikes: updatedLikes)
                self?.collectionDataProvider.updateUserProfile(with: updatedProfile) { updateResult in
                    DispatchQueue.main.async{
                        switch updateResult {
                        case .success(let updatedProfile):
                            print("Profile updated successfully: \(updatedProfile)")
                        case .failure(let error):
                            print("Error updating profile: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
        ProgressHUD.dismiss()
    }
    
    func addToCartButtonTapped(nft: Nft) {
        ProgressHUD.show()
        collectionDataProvider.getUserOrder { [weak self] result in
            switch result {
            case .success(let order):
                var updatedNfts = order.nfts ?? []
                if updatedNfts.contains(nft.id) {
                    updatedNfts.removeAll { $0 == nft.id }
                } else {
                    updatedNfts.append(nft.id)
                }
                let updatedOrder = order.update(newNfts: updatedNfts)
                self?.collectionDataProvider.updateUserOrder(with: updatedOrder) { updateResult in
                   
                        switch updateResult {
                        case .success(let updatedOrder):
                            print("Order updated successfully: \(updatedOrder)")
                        case .failure(let error):
                            print("Error updating order: \(error)")
                        }
                }
            case .failure(let error):
                print("Error fetching order: \(error)")
            }
        }
        ProgressHUD.dismiss()
    }
    func setUser(with newUser: NFTUser) {
        self.selectedUser = newUser
    }
    
    func getCollectionList() -> [Nft] {
        return collectionList
    }
}

extension UserCollectionPresenter: StatisticsUserNFTCollectionViewCellDelegate {
    func onLikeButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
        guard let nft = cell.getNftModel() else {return}
        self.onlikeButtonTapped(nft: nft)
    }
    
    func addToCartButtonTapped(cell: StatisticsUserNFTCollectionViewCell) {
        guard let nft = cell.getNftModel() else {return}
        self.addToCartButtonTapped(nft: nft)
    }
    
    func isNftLiked(_ nft: Nft, completion: @escaping (Bool) -> Void) {
        collectionDataProvider.getUserProfile { result in
           
                switch result {
                case .success(let profile):
                    let isLiked = profile.likes?.contains(nft.id) ?? false
                    completion(isLiked)
                case .failure:
                    completion(false)
                }
            
        }
    }
    
    func isNftInCart(_ nft: Nft, completion: @escaping (Bool) -> Void) {
        collectionDataProvider.getUserOrder { result in
           
                switch result {
                case .success(let order):
                    let isInCart = order.nfts?.contains(nft.id) ?? false
                    completion(isInCart)
                case .failure:
                    completion(false)
                }
            }
    }
}

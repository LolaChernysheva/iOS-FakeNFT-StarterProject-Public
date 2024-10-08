//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    func setup()
    func editProfile()
    func showWebsite(URL: URL)
    func updateProfileData()
}

final class ProfilePresenter {
    
    typealias Cell = ProfileScreenModel.TableData.Cell
    
    private weak var view: ProfileViewProtocol?
    private var router: ProfileRouterProtocol?
    private var networkService: ProfileNetworkServiceProtocol?
    private var profile: Profile?
    
    private(set) var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateLoadingState(isLoading: self.isLoading)
            }
        }
    }
    
    init(view: ProfileViewProtocol, router: ProfileRouterProtocol, networkService: ProfileNetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        loadProfile()
    }
    
    private func buildScreenModel() -> ProfileScreenModel {
        ProfileScreenModel(
            userName: profile?.name ?? "",
            userImage: profile?.avatar ?? UIImage(),
            userAbout: profile?.description ?? "",
            websiteUrlString: profile?.website ?? "",
            tableData: ProfileScreenModel.TableData(sections: [
                .simple(cells: [
                    buildMyNFTCell(),
                    buildFavorieNFTCell(),
                    buildAboutDeveloperCell()
                ])
            ])
        )
    }
    
    private func loadProfile() {
        isLoading = true
        networkService?.loadProfile(profileId: "1", completion: { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case let .success(profileResponce):
                self.profile = Profile(
                    name: profileResponce.name,
                    avatar: UIImage(),
                    description: profileResponce.description,
                    website: profileResponce.website,
                    nfts: profileResponce.nfts,
                    likes: profileResponce.likes,
                    id: profileResponce.id
                )
                self.loadImage(from: profileResponce.avatar) { result in
                    switch result {
                    case let .success(avatarImage):
                        self.profile?.avatar = avatarImage
                        DispatchQueue.main.async {
                            self.render()
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.render()
                        }
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.render()
                }
            }
        })
    }
    
    private func buildMyNFTCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("Мои NFT", comment: ""),
            subtitle: String(profile?.nfts.count ?? 0),
            action: { [weak self] in
                guard let self else { return }
                self.showMyNft()
            }))
    }
    
    private func buildFavorieNFTCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("Избранные NFT", comment: ""),
            subtitle: String(profile?.likes.count ?? 0),
            action: { [weak self] in
                guard let self else { return }
                self.showFavoriteNfts()
            }))
    }
    
    private func buildAboutDeveloperCell() -> Cell {
        .detail(DetailCellModel(
            title: NSLocalizedString("О разработчике", comment: ""),
            subtitle: "",
            action: {
                
            }))
    }
    
    private func render(reloadTableData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadTableData)
    }
    
    private func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case let .success(value):
                completion(.success(value.image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func showMyNft() {
        guard let profile = profile else { return }
        router?.showMyNftController(profile: profile)
    }
    
    private func showFavoriteNfts() {
        guard let profile = profile else { return }
        router?.showFavoriteNfts(profile: profile)
    }
}

// MARK: ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func setup() {
        render()
    }
    
    func editProfile() {
        guard let profile = profile else { return }
        router?.showEditProfileController(profile: profile, onDismiss: { [weak self] in
            guard let self else { return }
            self.updateProfileData()
        })
    }
    
    func showWebsite(URL: URL) {
        router?.showWebview(URL: URL)
    }
    
    func updateProfileData() {
        loadProfile()
    }
}

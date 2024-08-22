//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 25.07.2024.
//  
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
    func showEditProfileController(profile: Profile, onDismiss: @escaping () -> Void)
    func showMyNftController(profile: Profile)
    func showWebview(URL: URL)
    func showFavoriteNfts(profile: Profile)
}

final class ProfileRouter: ProfileRouterProtocol {
    
    private weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func showEditProfileController(profile: Profile, onDismiss: @escaping () -> Void) {
        guard let view = view as? UIViewController else { return }
        let editProfileViewController = ModulesAssembly.editProfileScreenBuilder(profile: profile, onDismiss: onDismiss)
        editProfileViewController.modalPresentationStyle = .pageSheet
        editProfileViewController.hidesBottomBarWhenPushed = true
        view.present(editProfileViewController, animated: true)
    }
    
    func showMyNftController(profile: Profile) {
        guard let view = view as? UIViewController else { return }
        let myNftController = ModulesAssembly.myNftScreenBuilder(profile: profile)
        myNftController.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(myNftController, animated: true)
    }
    
    func showWebview(URL: URL) {
        guard let view = view as? UIViewController else { return }
        let webViewController = ProfileWebViewController(urlString: URL.absoluteString)
        webViewController.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showFavoriteNfts(profile: Profile) {
        guard let view = view as? UIViewController else { return }
        let favoriteNftsController = ModulesAssembly.favoriteNftsScreenBuilder(profile: profile)
        favoriteNftsController.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(favoriteNftsController, animated: true)
    }
}

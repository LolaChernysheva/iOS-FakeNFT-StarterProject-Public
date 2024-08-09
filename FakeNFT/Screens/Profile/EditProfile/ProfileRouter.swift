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
    func showMyNftController(nftIds: [String])
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
    
    func showMyNftController(nftIds: [String]) {
        guard let view = view as? UIViewController else { return }
        let myNftController = ModulesAssembly.myNftScreenBuilder(nftIds: nftIds)
        view.navigationController?.pushViewController(myNftController, animated: true)
    }
}

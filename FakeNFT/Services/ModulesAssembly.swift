//
//  ModulesAssembly.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

protocol ModulesAssemblyProtocol: AnyObject {
    static func mainScreenBuilder() -> UIViewController
    static func editProfileScreenBuilder(profile: Profile, onDismiss: @escaping () -> Void) -> UIViewController
    static func myNftScreenBuilder(profile: Profile) -> UIViewController
    static func favoriteNftsScreenBuilder(profile: Profile) -> UIViewController
}

final class ModulesAssembly: ModulesAssemblyProtocol {
    
    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
        
        let profileViewController = Self.profileScreenBuilder()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)
        
        tabbarController.viewControllers = [profileViewController]
        
        return tabbarController
    }
    
    static func profileScreenBuilder() -> UIViewController {
        let profileViewController = ProfileViewController()
        let networkClient = DefaultNetworkClient()
        let router = ProfileRouter(view: profileViewController)
        let networkServive = ProfileNetworkService(networkClient: networkClient)
        let nc = UINavigationController(rootViewController: profileViewController)
        let profilePresenter = ProfilePresenter(view: profileViewController, router: router, networkService: networkServive)
        profileViewController.presenter = profilePresenter
        return nc
    }
    
    static func editProfileScreenBuilder(profile: Profile, onDismiss: @escaping () -> Void) -> UIViewController {
        let editProfileViewController = EditProfileViewController(onDismiss: onDismiss)
        let networkClient = DefaultNetworkClient()
        let networkService = ProfileNetworkService(networkClient: networkClient)
        let presenter = EditProfilePresenter(view: editProfileViewController, profile: profile, networkService: networkService)
        editProfileViewController.presenter = presenter
        return editProfileViewController
    }
    
    static func myNftScreenBuilder(profile: Profile) -> UIViewController {
        let myNftViewController = MyNFTViewController()
        let networkClient = DefaultNetworkClient()
        let networkService = MyNftNetworkService(networkClient: networkClient)
        let profileNetworkService = ProfileNetworkService(networkClient: networkClient)
        let myNftPresenter = MyNFTPresenter(view: myNftViewController, networkService: networkService, profileService: profileNetworkService, profile: profile)
        myNftViewController.presenter = myNftPresenter
        return myNftViewController
    }
    
    static func favoriteNftsScreenBuilder(profile: Profile) -> UIViewController {
        let favoriteNftsController = FavoriteNFTViewController()
        let networkClient = DefaultNetworkClient()
        let networkService = MyNftNetworkService(networkClient: networkClient)
        let profileNetworkService = ProfileNetworkService(networkClient: networkClient)
        let favoriteNftsPresenter = FavoriteNFTPresenter(view: favoriteNftsController, service: networkService, profileService: profileNetworkService, profile: profile)
        favoriteNftsController.presenter = favoriteNftsPresenter
        return favoriteNftsController
    }
}

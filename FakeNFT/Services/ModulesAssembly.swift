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
    static func editProfileScreenBuilder(profile: Profile) -> UIViewController
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
    
    static func editProfileScreenBuilder(profile: Profile) -> UIViewController {
        let editProfileViewController = EditProfileViewController()
        let presenter = EditProfilePresenter(view: editProfileViewController, profile: profile)
        editProfileViewController.presenter = presenter
        return editProfileViewController
    }
}

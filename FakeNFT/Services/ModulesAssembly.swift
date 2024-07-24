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
}

final class ModulesAssembly: ModulesAssemblyProtocol {

    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()

        let profileViewController = Self.profileScreenBuilder()
        let navCartViewController = UINavigationController(
            rootViewController: Self.cartScreenBuilder()
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)

        navCartViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Корзина", comment: ""),
            image: Asset.Images.tabBarCart,
            tag: 2
        )

        tabbarController.viewControllers = [profileViewController, navCartViewController]

        return tabbarController
    }

    static func profileScreenBuilder() -> UIViewController {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController)
        profileViewController.presenter = profilePresenter

        return profileViewController
    }

    static func cartScreenBuilder() -> UIViewController {
        let cartService = CartService()
        let cartPresenter = CartPresenter(cartService: cartService)
        let cartViewController = CartViewController(presenter: cartPresenter)
        cartPresenter.view = cartViewController

        return cartViewController
    }
}

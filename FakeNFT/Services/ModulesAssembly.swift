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
        tabbarController.tabBar.unselectedItemTintColor = UIColor.segmentActive
        
        let profileViewController = Self.profileScreenBuilder()
        let navCartViewController = UINavigationController(
            rootViewController: Self.cartScreenBuilder()
        )
        let statisticsViewController = Self.statisticsScreenBuilder()

        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)

        navCartViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Корзина", comment: ""),
            image: Asset.Images.tabBarCart,
            tag: 2
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(systemName: "flag.2.crossed.fill"),
            tag: 3)

        tabbarController.viewControllers = [
            profileViewController,
            navCartViewController,
            statisticsViewController
        ]

        return tabbarController
    }
    
    static func statisticsScreenBuilder() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        let statisticsPresenter = StatisticsPresenter(view: statisticsViewController)
        statisticsViewController.presenter = statisticsPresenter
        return statisticsViewController
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

    static func currenciesScreenBuilder() -> UIViewController {
        let currenciesPresenter = PaymentPresenter(currenciesService: PaymentService())
        let currenciesViewController = PaymentViewController(presenter: currenciesPresenter)
        currenciesPresenter.view = currenciesViewController

        return currenciesViewController
    }
}

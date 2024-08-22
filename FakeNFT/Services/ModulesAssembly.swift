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
        tabbarController.tabBar.unselectedItemTintColor = UIColor.segmentActive

        let profileViewController = Self.profileScreenBuilder()
        let navCartViewController = UINavigationController(
            rootViewController: Self.cartScreenBuilder())
        let statisticsViewController = Self.statisticsScreenBuilder()
        let catalogViewController = UINavigationController(
            rootViewController: Self.catalogScreenBuilder()
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)

        catalogViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Каталог", comment: ""),
            image: Asset.Images.tabBarCatalog,
            tag: 1)

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
            catalogViewController,
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

    static func catalogScreenBuilder() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(
            networkClient: networkClient
        )
        let presenter = CatalogPresenter(
            dataProvider: dataProvider
        )
        let cartService = CartServicee()
        let catalogViewController = CatalogViewController(
            presenter: presenter,
            cartService: cartService
        )
        return catalogViewController
    }

    func сatalogСollection(nftModel: NFTCollection) -> UIViewController {
        let dataProvider = CollectionDataProvider(networkClient: DefaultNetworkClient())
        let presenter = CatalogСollectionPresenter(nftModel: nftModel, dataProvider: dataProvider, cartController: CartServicee())
        let viewController = CatalogСollectionViewController(presenter: presenter, das: nftModel)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

}

final class CartServicee: CartControllerProtocol {
    var cart: [Nft] = []
    func addToCart(
        _ nft: Nft,
        completion: (
    () -> Void
        )?
    ) {

    }
    func removeFromCart(
        _ id: String,
        completion: (
    () -> Void
        )?
    ) {

    }
    func removeAll(
        completion: (
    () -> Void
        )?
    ) {

    }
    weak var delegate: CartControllerDelegate?
    private var _cart: [Nft] = []
}

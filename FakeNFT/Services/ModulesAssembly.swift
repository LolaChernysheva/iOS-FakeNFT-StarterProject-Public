//
//  ModulesAssembly.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//
//

import UIKit

final class CartService: CartControllerProtocol {
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

protocol ModulesAssemblyProtocol: AnyObject {
    static func mainScreenBuilder() -> UIViewController
}

final class ModulesAssembly: ModulesAssemblyProtocol {

    static let shared = ModulesAssembly()

    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
<<<<<<< HEAD

        let profileViewController = UINavigationController(
            rootViewController: Self.catalogScreenBuilder()
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "Каталог",
                comment: ""
            ),
            image: Asset.Images.tabBarCatalog,
            tag: 0
        )

        tabbarController.viewControllers = [profileViewController]

        return tabbarController
    }

    static func catalogScreenBuilder() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(
            networkClient: networkClient
        )
        let presenter = CatalogPresenter(
            dataProvider: dataProvider
        )
        let cartService = CartService()
        let catalogViewController = CatalogViewController(
            presenter: presenter,
            cartService: cartService
        )
        return catalogViewController
    }

    func catalogСollection(
        nftModel: NFTCollection
    ) -> UIViewController {
        let dataProvider = CollectionDataProvider(
            networkClient: DefaultNetworkClient()
        )
        let presenter = CatalogСollectionPresenter(
            nftModel: nftModel,
            dataProvider: dataProvider,
            cartController: CartService()
        )
        let viewController = CatalogСollectionViewController(
            presenter: presenter
        )
        viewController.hidesBottomBarWhenPushed = true
        return viewController
=======
        
        let statisticsViewController = Self.statisticsScreenBuilder()
        
   
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(systemName: "flag.2.crossed.fill"),
            tag: 3)
        
        
        tabbarController.viewControllers = [statisticsViewController]
        
        return tabbarController
    }
    
    static func statisticsScreenBuilder() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        let statisticsPresenter = StatisticsPresenter(view: statisticsViewController)
        statisticsViewController.presenter = statisticsPresenter
        return statisticsViewController
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    }

}

import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: Asset.Images.tabBarStatistic,
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [statisticsController]

<<<<<<< HEAD
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(networkClient: networkClient)
        let presenter = CatalogPresenter(dataProvider: dataProvider)
        let cartService = CartService()
        let catalogController = CatalogViewController(presenter: presenter, cartService: cartService)

        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
=======
        view.backgroundColor = .nftWhite
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    }
}

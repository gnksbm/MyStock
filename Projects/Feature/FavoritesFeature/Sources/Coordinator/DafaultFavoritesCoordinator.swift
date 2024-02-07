import UIKit

import Domain
import FeatureDependency

public final class DefaultFavoritesCoordinator: FavoritesCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let favoritesViewController = FavoritesViewController(
            viewModel: FavoritesViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [favoritesViewController],
            animated: false
        )
    }
}

public extension DefaultFavoritesCoordinator {
    func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchStockCoordinator(
            searchResult: .stockInfo, 
            navigationController: navigationController
        )
        startChildCoordinator(searchCoordinator)
    }
    
    func startChartFlow(with response: SearchStocksResponse) {
        let chartCoordinator = coordinatorProvider.makeChartCoordinator(
            title: response.name,
            ticker: response.ticker,
            marketType: response.marketType,
            navigationController: navigationController
        )
        startChildCoordinator(chartCoordinator)
    }
}

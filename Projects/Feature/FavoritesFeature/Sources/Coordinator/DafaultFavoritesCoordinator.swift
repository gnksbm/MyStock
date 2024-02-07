import UIKit

import FeatureDependency

public final class DefaultFavoritesCoordinator {
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
    
    public func finish() {
        
    }
}

extension DefaultFavoritesCoordinator: FavoritesCoordinator {
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchStockCoordinator(
            navigationController: navigationController
        )
        startChildCoordinator(searchCoordinator)
    }
}

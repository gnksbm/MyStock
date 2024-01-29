import UIKit

import FeatureDependency

public final class DefaultFavoritesCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let favoritesViewController = FavoritesViewController(
            viewModel: FavoritesViewModel()
        )
        navigationController.setViewControllers(
            [favoritesViewController],
            animated: false
        )
    }
}

extension DefaultFavoritesCoordinator: FavoritesCoordinator {
    public func startSearchFlow() {
        let search
    }
}

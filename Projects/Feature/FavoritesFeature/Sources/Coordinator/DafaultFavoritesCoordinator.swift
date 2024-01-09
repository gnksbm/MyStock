import UIKit

import FeatureDependency

public final class DefaultFavoritesCoordinator: FavoritesCoordinator {
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

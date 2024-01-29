import UIKit

import FeatureDependency

public final class DefaultFavoritesCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
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
    
    public func finish() {
        
    }
}

extension DefaultFavoritesCoordinator: FavoritesCoordinator {
    public func startSearchFlow() {
        
    }
}

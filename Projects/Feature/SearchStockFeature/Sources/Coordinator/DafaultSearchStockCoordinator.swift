import UIKit

import FeatureDependency

public final class DefaultSearchStockCoordinator: SearchStockCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let searchstockViewController = SearchStockViewController(
            viewModel: SearchStockViewModel()
        )
        navigationController.setViewControllers(
            [searchstockViewController],
            animated: false
        )
    }
}

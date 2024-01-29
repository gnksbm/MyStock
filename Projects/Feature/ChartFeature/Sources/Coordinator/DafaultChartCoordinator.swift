import UIKit

import FeatureDependency

public final class DefaultChartCoordinator: ChartCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let chartViewController = ChartViewController(
            viewModel: ChartViewModel()
        )
        navigationController.setViewControllers(
            [chartViewController],
            animated: false
        )
    }
}

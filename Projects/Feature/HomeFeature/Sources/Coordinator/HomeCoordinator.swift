import UIKit

import FeatureDependency

public final class HomeCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
    }
    
    public func createHomeViewController() -> UINavigationController {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel()
        )
        navigationController = UINavigationController(
            rootViewController: homeViewController
        )
        return navigationController
    }
}

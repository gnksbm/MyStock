import UIKit

import FeatureDependency

public final class tempCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
    }
    
    public func createtempViewController() -> UINavigationController {
        let tempViewController = tempViewController(
            viewModel: tempViewModel()
        )
        navigationController = UINavigationController(rootViewController: tempViewController)
        return navigationController
    }
}

import UIKit

import FeatureDependency

public final class DefaultDetailCoordinator: DetailCoordinator {
    public var navigationController: UINavigationController
    
    public var parent: Coordinator?
    public var childs = [Coordinator]()
    
    public init(
        parent: Coordinator? = nil,
        navigationController: UINavigationController
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }
    
    public func start() {
        let detailViewController = DetailViewController()
        detailViewController.reactor = DetailReactor()
        navigationController.setViewControllers(
            [detailViewController],
            animated: false
        )
    }
}

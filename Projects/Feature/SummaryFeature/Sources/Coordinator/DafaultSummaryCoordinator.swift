import UIKit

import FeatureDependency

public final class DefaultSummaryCoordinator: SummaryCoordinator {
    public var coordinatorProvider: CoordinatorProvider
    
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let summaryViewController = SummaryViewController()
        summaryViewController.reactor = SummaryReactor(coordinator: self)
        navigationController.setViewControllers(
            [summaryViewController],
            animated: false
        )
    }
}

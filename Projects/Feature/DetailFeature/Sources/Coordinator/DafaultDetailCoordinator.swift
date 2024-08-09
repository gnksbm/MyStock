import UIKit

import Domain
import FeatureDependency

public final class DefaultDetailCoordinator {
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
        detailViewController.reactor = DetailReactor(
            ticker: "",
            useCase: DefaultDetailUseCase()
        )
        navigationController.setViewControllers(
            [detailViewController],
            animated: false
        )
    }
}

extension DefaultDetailCoordinator: DetailCoordinator {
    public func startDetailFlow(ticker: String) {
        let detailViewController = DetailViewController()
        detailViewController.reactor = DetailReactor(
            ticker: ticker,
            useCase: DefaultDetailUseCase()
        )
        navigationController.setViewControllers(
            [detailViewController],
            animated: false
        )
    }
}

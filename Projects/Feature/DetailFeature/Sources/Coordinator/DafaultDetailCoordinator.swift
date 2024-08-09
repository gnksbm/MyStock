import UIKit

import Domain
import FeatureDependency

public final class DefaultDetailCoordinator: DetailCoordinator {
    public let ticker: String
    
    public let navigationController: UINavigationController
    public var parent: Coordinator?
    public var childs = [Coordinator]()
    
    public init(
        ticker: String,
        parent: Coordinator? = nil,
        navigationController: UINavigationController
    ) {
        self.ticker = ticker
        self.parent = parent
        self.navigationController = navigationController
    }
    
    public func start() {
        let detailViewController = DetailViewController()
        detailViewController.reactor = DetailReactor(
            ticker: ticker,
            coordinator: self,
            useCase: DefaultDetailUseCase()
        )
        navigationController.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

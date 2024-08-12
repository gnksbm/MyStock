import UIKit

import Domain
import FeatureDependency

public final class DefaultDetailCoordinator {
    public let ticker: String
    
    public let coordinatorProvider: CoordinatorProvider
    public let navigationController: UINavigationController
    public var parent: Coordinator?
    public var childs = [Coordinator]()
    
    public init(
        ticker: String,
        parent: Coordinator? = nil,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.ticker = ticker
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
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

extension DefaultDetailCoordinator: DetailCoordinator {
    public func startChartFlow(title: String, ticker: String) {
        let chartCoordinator = coordinatorProvider.makeChartCoordinator(
            title: title,
            ticker: ticker,
            marketType: .domestic,
            navigationController: navigationController
        )
        startChildCoordinator(chartCoordinator)
    }
}

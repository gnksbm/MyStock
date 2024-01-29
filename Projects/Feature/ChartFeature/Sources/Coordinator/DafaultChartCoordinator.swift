import UIKit

import Domain
import FeatureDependency

public final class DefaultChartCoordinator: ChartCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public let title: String
    public let ticker: String
    public let marketType: MarketType
    
    public init(
        title: String,
        ticker: String,
        marketType: MarketType,
        navigationController: UINavigationController
    ) {
        self.title = title
        self.ticker = ticker
        self.marketType = marketType
        self.navigationController = navigationController
    }
    
    public func start() {
        let chartViewController = ChartViewController(
            viewModel: ChartViewModel(
                title: title,
                ticker: ticker,
                marketType: marketType
            )
        )
        navigationController.pushViewController(
            chartViewController,
            animated: false
        )
    }
}

import UIKit

import Domain
import FeatureDependency

public protocol HomeCoordinator: Coordinator {
    func startChartFlow(with response: KISCheckBalanceResponse)
    func startSearchStocksFlow()
}

import Foundation

import Domain
import FeatureDependency

public protocol FavoritesCoordinator: Coordinator {
    func startSearchFlow()
    func startChartFlow(with response: SearchStocksResponse)
}

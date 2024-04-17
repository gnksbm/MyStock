import Foundation

import Domain

public protocol FavoritesCoordinator: Coordinator {
    func startSearchFlow()
    func startChartFlow(with response: SearchStocksResponse)
}

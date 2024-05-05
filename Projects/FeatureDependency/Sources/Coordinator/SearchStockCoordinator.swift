import Foundation

import Domain

public protocol SearchStockCoordinator: Coordinator {
    var searchResult: SearchFlow { get }
    
    func startChartFlow(with response: SearchStocksResponse)
    func updateFavoritesFinished()
}

public enum SearchFlow {
    case chart, stockInfo
}

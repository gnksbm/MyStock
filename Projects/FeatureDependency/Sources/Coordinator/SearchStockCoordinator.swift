import Foundation

import Domain

public protocol SearchStockCoordinator: Coordinator {
    var searchResult: SearchResult { get }
    
    func startChartFlow(with response: SearchStocksResponse)
    func updateFavoritesFinished()
}

public enum SearchResult {
    case chart, stockInfo
}

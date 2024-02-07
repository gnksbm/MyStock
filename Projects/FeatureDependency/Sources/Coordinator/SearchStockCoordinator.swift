import Foundation

import Domain

public protocol SearchStockCoordinator: Coordinator {
    var searchResult: SearchResult { get }
    
    func pushToChartVC(with response: SearchStocksResponse)
    func updateFavoritesFinished()
}

public enum SearchResult {
    case chart, stockInfo
}

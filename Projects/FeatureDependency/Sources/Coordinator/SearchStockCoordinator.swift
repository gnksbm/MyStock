import Foundation

import Domain

public protocol SearchStockCoordinator: Coordinator {
    func pushToChartVC(with response: SearchStocksResponse)
}

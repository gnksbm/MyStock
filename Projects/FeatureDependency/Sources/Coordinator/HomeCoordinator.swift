import UIKit

import Domain

public protocol HomeCoordinator: Coordinator {
    func startChartFlow(with response: KISCheckBalanceResponse)
    func startSearchStocksFlow()
}

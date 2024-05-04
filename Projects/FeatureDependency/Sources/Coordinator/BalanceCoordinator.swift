import UIKit

import Domain

public protocol BalanceCoordinator: Coordinator {
    func startChartFlow(with response: KISCheckBalanceResponse)
    func startSearchStocksFlow()
}

import UIKit

import Domain
import FeatureDependency

public protocol HomeCoordinator: Coordinator {
    func pushToChartVC(with response: KISCheckBalanceResponse)
    func startSearchStocksFlow()
}

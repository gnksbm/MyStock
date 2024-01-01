import UIKit

import Domain
import FeatureDependency

public protocol HomeCoordinator: Coordinator {
    func push(with response: KISCheckBalanceResponse)
}

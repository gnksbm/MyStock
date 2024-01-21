//
//  DefaultHomeCoordinator.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultHomeCoordinator: HomeCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
}

public extension DefaultHomeCoordinator {
    func pushToChartVC(with response: KISCheckBalanceResponse) {
        let homeChartVC = HomeChartViewController(
            viewModel: .init(
                title: response.name,
                ticker: response.ticker,
                marketType: .domestic
            )
        )
        navigationController.pushViewController(homeChartVC, animated: true)
    }
    
    func startSearchStocksFlow() {
        let searchStocksCoordinator = DefaultSearchStocksCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(searchStocksCoordinator)
        searchStocksCoordinator.start()
    }
}

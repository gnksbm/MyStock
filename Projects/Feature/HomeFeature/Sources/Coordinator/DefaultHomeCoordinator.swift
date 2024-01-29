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
    public var coordinatorProvider: CoordinatorProvider

    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
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
        let searchStockCoordinator = coordinatorProvider
            .makeSearchStockCoordinator(
                navigationController: navigationController
            )
        childCoordinators.append(searchStockCoordinator)
        searchStockCoordinator.start()
    }
}

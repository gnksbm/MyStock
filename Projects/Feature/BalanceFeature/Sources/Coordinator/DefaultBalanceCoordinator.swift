//
//  DefaultBalanceCoordinator.swift
//  BalanceFeature
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultBalanceCoordinator: BalanceCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
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
        let homeViewController = BalanceViewController(
            viewModel: BalanceViewModel(
                useCase: DefaultBalanceUseCase(),
                coordinator: self
            )
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
}

public extension DefaultBalanceCoordinator {
    func startChartFlow(with response: KISCheckBalanceResponse) {
        let chartCoordinator = coordinatorProvider.makeChartCoordinator(
            title: response.name,
            ticker: response.ticker,
            marketType: .domestic,
            navigationController: navigationController
        )
        startChildCoordinator(chartCoordinator)
    }
    
    func startSearchStocksFlow() {
        let searchStockCoordinator = coordinatorProvider
            .makeSearchStockCoordinator(
                searchResult: .chart, 
                navigationController: navigationController
            )
        startChildCoordinator(searchStockCoordinator)
    }
}

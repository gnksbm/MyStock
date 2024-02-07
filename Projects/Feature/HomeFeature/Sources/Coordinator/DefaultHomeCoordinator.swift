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
        let homeViewController = HomeViewController(
            viewModel: HomeViewModel(coordinator: self)
        )
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
    
    public func finish() {
        
    }
}

public extension DefaultHomeCoordinator {
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

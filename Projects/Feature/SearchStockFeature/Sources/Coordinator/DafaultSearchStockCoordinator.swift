//
//  DefaultSearchStockCoordinator.swift
//  HomeFeature
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchStockCoordinator: SearchStockCoordinator {
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
        let searchStocksViewController = SearchStockViewController(
            viewModel: SearchStockViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            searchStocksViewController,
            animated: true
        )
    }
    
    public func finish() {
        
    }
}

public extension DefaultSearchStockCoordinator {
    func pushToChartVC(with response: SearchStocksResponse) {
        let chartCoordinator = coordinatorProvider.makeChartCoordinator(
            title: response.name,
            ticker: response.ticker,
            marketType: response.marketType,
            navigationController: navigationController
        )
        startChildCoordinator(chartCoordinator)
    }
}

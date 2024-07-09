//
//  DefaultSearchStockCoordinator.swift
//  SearchFeature
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchStockCoordinator: SearchStockCoordinator {
    public var searchFlow: SearchFlow
    
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    
    public init(
        searchFlow: SearchFlow,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.searchFlow = searchFlow
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let searchStocksViewController = SearchStockViewController()
        searchStocksViewController.reactor = SearchStockReactor(
            useCase: DefaultSearchStocksUseCase(),
            searchFlow: searchFlow,
            coordinator: self
        )
        navigationController.pushViewController(
            searchStocksViewController,
            animated: true
        )
    }
}

public extension DefaultSearchStockCoordinator {
    func startChartFlow(with response: SearchStocksResponse) {
        let chartCoordinator = coordinatorProvider.makeChartCoordinator(
            title: response.name,
            ticker: response.ticker,
            marketType: response.marketType,
            navigationController: navigationController
        )
        startChildCoordinator(chartCoordinator)
    }
    
    func updateFavoritesFinished() {
        navigationController.popViewController(animated: true)
        parent?.childDidFinish(self)
    }
}

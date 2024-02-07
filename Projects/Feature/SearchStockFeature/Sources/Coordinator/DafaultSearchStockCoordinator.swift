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
    public var searchResult: SearchResult
    
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    
    public init(
        searchResult: SearchResult,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.searchResult = searchResult
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let searchStocksViewController = SearchStockViewController(
            viewModel: SearchStockViewModel(
                searchResult: searchResult,
                coordinator: self
            )
        )
        navigationController.pushViewController(
            searchStocksViewController,
            animated: true
        )
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
    
    func updateFavoritesFinished() {
        navigationController.popViewController(animated: true)
        parent?.childDidFinish(self)
    }
}

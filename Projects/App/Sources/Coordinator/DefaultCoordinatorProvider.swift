//
//  DefaultCoordinatorProvider.swift
//  App
//
//  Created by gnksbm on 1/29/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import ChartFeature
import DetailFeature
import Domain
import FeatureDependency
import SearchStockFeature
import SettingsFeature

final class DefaultCoordinatorProvider: CoordinatorProvider {
    func makeSearchStockCoordinator(
        searchFlow: SearchFlow,
        navigationController: UINavigationController
    ) -> SearchStockCoordinator {
        DefaultSearchStockCoordinator(
            searchFlow: searchFlow,
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
    
    func makeChartCoordinator(
        title: String,
        ticker: String,
        marketType: MarketType,
        navigationController: UINavigationController
    ) -> ChartCoordinator {
        DefaultChartCoordinator(
            title: title,
            ticker: ticker,
            marketType: marketType,
            navigationController: navigationController
        )
    }
    
    func makeApiSettingsCoordinator(
        parent: Coordinator?,
        navigationController: UINavigationController
    ) -> APISettingsCoordinator {
        DefaultAPISettingsCoordinator(
            parent: parent,
            navigationController: navigationController
        )
    }
    
    func makeDetailCoordinator(
        ticker: String,
        parent: (any Coordinator)?,
        navigationController: UINavigationController
    ) -> any DetailCoordinator {
        DefaultDetailCoordinator(
            ticker: ticker,
            parent: parent,
            navigationController: navigationController, 
            coordinatorProvider: self
        )
    }
}

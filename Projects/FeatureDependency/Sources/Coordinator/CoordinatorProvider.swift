//
//  CoordinatorProvider.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/29/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain

public protocol CoordinatorProvider {
    func makeSearchStockCoordinator(
        searchFlow: SearchFlow,
        navigationController: UINavigationController
    ) -> SearchStockCoordinator
    
    func makeChartCoordinator(
        title: String,
        ticker: String,
        marketType: MarketType,
        navigationController: UINavigationController
    ) -> ChartCoordinator
    
    func makeApiSettingsCoordinator(
        parent: Coordinator?,
        navigationController: UINavigationController
    ) -> APISettingsCoordinator
}

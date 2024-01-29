//
//  DefaultCoordinatorProvider.swift
//  App
//
//  Created by gnksbm on 1/29/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import SearchStockFeature
import ChartFeature
import FeatureDependency

final class DefaultCoordinatorProvider: CoordinatorProvider {
    func makeSearchStockCoordinator(
        navigationController: UINavigationController
    ) -> SearchStockCoordinator {
        DefaultSearchStockCoordinator(
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
    
    func makeChartCoordinator(
        navigationController: UINavigationController
    ) -> ChartCoordinator {
        DefaultChartCoordinator(
            navigationController: navigationController
        )
    }
}

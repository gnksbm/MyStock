//
//  CoordinatorProvider.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/29/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public protocol CoordinatorProvider {
    func makeSearchStockCoordinator(
        navigationController: UINavigationController
    ) -> SearchStockCoordinator
    func makeChartCoordinator(
        navigationController: UINavigationController
    ) -> ChartCoordinator
}

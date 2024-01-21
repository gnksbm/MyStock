//
//  DefaultSearchStocksCoordinator.swift
//  HomeFeature
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultSearchStocksCoordinator: SearchStocksCoordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let searchStocksViewController = SearchStocksViewController(
            viewModel: SearchStocksViewModel(coordinator: self)
        )
        navigationController.pushViewController(
            searchStocksViewController,
            animated: true
        )
    }
}

public extension DefaultSearchStocksCoordinator {
    func pushToChartVC(with response: SearchStocksResponse) {
        let homeChartVC = HomeChartViewController(
            viewModel: .init(
                title: response.name,
                ticker: response.ticker,
                marketType: response.marketType
            )
        )
        navigationController.pushViewController(homeChartVC, animated: true)
    }
}

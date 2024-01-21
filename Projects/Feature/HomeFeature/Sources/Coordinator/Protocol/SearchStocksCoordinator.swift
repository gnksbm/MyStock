//
//  SearchStocksCoordinator.swift
//  HomeFeature
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

public protocol SearchStocksCoordinator: Coordinator {
    func pushToChartVC(with response: SearchStocksResponse)
}

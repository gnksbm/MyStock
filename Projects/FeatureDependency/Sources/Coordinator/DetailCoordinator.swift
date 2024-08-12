//
//  DetailCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol DetailCoordinator: Coordinator {
    func startChartFlow(title: String, ticker: String)
}

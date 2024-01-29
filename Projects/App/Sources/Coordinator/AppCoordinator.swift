//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import FeatureDependency
import MainFeature

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

//
//  TabBarCoordinator.swift
//  App
//
//  Created by gnksbm on 2024/01/08.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import HomeFeature

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeCoordinator = DefaultHomeCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

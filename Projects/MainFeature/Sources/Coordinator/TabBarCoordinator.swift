//
//  TabBarCoordinator.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/08.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import HomeFeature
import FavoritesFeature
import SettingsFeature

public final class TabBarCoordinator: Coordinator {
    public var childCoordinators: [FeatureDependency.Coordinator] = []
    public var navigationController: UINavigationController
    public var coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        let tabBarController = TabBarViewController()
        
        navigationController.setViewControllers(
            [tabBarController], animated: true
        )
        
        let viewControllers = MainTab.allCases.map {
            makeNavigationController(tabKind: $0)
        }
        
        tabBarController.viewControllers = viewControllers
    }
    
    private func makeNavigationController(
        tabKind: MainTab
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabKind.tabItem
        setupChildCoordinators(
            tabKind: tabKind,
            navigationController: navigationController
        )
        return navigationController
    }
    
    private func setupChildCoordinators(
        tabKind: MainTab,
        navigationController: UINavigationController
    ) {
        var coordinator: Coordinator
        switch tabKind {
        case .home:
            coordinator = DefaultHomeCoordinator(
                navigationController: navigationController, 
                coordinatorProvider: coordinatorProvider
            )
        case .favorites:
            coordinator = DefaultFavoritesCoordinator(
                navigationController: navigationController
            )
        case .setting:
            coordinator = DefaultSettingsCoordinator(
                navigationController: navigationController
            )
        }
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

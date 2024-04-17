//
//  DefaultAPISettingsCoordinator.swift
//  SettingsFeature
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import FeatureDependency

public final class DefaultAPISettingsCoordinator: APISettingsCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }
    
    public func start() {
        let apiSettingsViewController = APISettingsViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.pushViewController(
            apiSettingsViewController,
            animated: true
        )
    }
}

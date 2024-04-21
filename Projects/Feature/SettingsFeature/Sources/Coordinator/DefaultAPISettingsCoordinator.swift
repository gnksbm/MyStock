//
//  DefaultAPISettingsCoordinator.swift
//  SettingsFeature
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultAPISettingsCoordinator: APISettingsCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    private var qrDelegate: APISettingsViewModel?
    
    public init(
        parent: Coordinator?,
        navigationController: UINavigationController
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewModel = APISettingsViewModel(
            useCase: DefaultSettingsUseCase(),
            coordinator: self
        )
        qrDelegate = viewModel
        let apiSettingsViewController = APISettingsViewController(
            viewModel: viewModel
        )
        navigationController.pushViewController(
            apiSettingsViewController,
            animated: true
        )
    }
}

extension DefaultAPISettingsCoordinator {
    public func startQRCodeReaderFlow() {
        let qrCodeReaderCoordinator = DefaultQRCodeReaderCoordinator(
            parent: self,
            delegate: qrDelegate,
            navigationController: navigationController
        )
        childs.append(qrCodeReaderCoordinator)
        qrCodeReaderCoordinator.presentViewController()
    }
}

//
//  DefaultQRCodeReaderCoordinator.swift
//  SettingsFeature
//
//  Created by gnksbm on 4/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import FeatureDependency

public final class DefaultQRCodeReaderCoordinator: QRCodeReaderCoordinator {
    public var delegate: QRCodeReaderCoordinatorFinishDelegate?
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public let navigationController: UINavigationController
    
    public init(
        parent: Coordinator? = nil,
        delegate:QRCodeReaderCoordinatorFinishDelegate? = nil,
        navigationController: UINavigationController
    ) {
        self.parent = parent
        self.delegate = delegate
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = QRCodeReaderViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
}

extension DefaultQRCodeReaderCoordinator {
    public func presentViewController() {
        let viewController = QRCodeReaderViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.present(
            viewController,
            animated: true
        )
    }
    
    public func finishWithData(data: Data) {
        delegate?.capturedData(data: data)
    }
}

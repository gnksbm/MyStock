//
//  QRCodeReaderCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 4/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol QRCodeReaderCoordinator: Coordinator {
    var delegate: QRCodeReaderCoordinatorFinishDelegate? { get set }
    
    func presentViewController()
    func finishWithData(data: Data)
}

public protocol QRCodeReaderCoordinatorFinishDelegate: AnyObject {
    func capturedData(data: Data)
}

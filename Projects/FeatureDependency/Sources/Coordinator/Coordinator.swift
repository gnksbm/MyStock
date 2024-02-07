//
//  Coordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/11/25.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var childs: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}

public extension Coordinator {
    func startChildCoordinator(_ child: Coordinator) {
        childs.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        childs = childs.filter { $0 !== child }
    }
}

//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import FeatureDependency
import HomeFeature
import RxSwift

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let price = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(
            navigationController: navigationController
        )
        price.bind {
            homeCoordinator.price.onNext($0)
        }.disposed(by: disposeBag)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

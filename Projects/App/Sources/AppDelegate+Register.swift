//
//  AppDelegate+Register.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation
import Core
import Data
import Domain

extension AppDelegate {
    func registerDependencies() {
        DIContainer.register(
            type: TempRepository.self,
            DefaultTempRepository()
        )
    }
}

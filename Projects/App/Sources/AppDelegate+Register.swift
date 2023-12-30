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
import Networks

extension AppDelegate {
    func registerDependencies() {
        DIContainer.register(
            type: HomeUseCase.self,
            DefaultHomeUseCase(
                oAuthRepository: oAuthRepository,
                checkBalanceRepository: checkBalanceRepository
            )
        )
    }
}

extension AppDelegate {
    var networkService: NetworkService {
        DefaultNetworkService()
    }
    
    var webSocketService: WebSocketService {
        DefaultWebSocketService()
    }
}

extension AppDelegate {
    var oAuthRepository: KISOAuthRepository {
        DefaultKISOAuthRepository(networkService: networkService)
    }
    
    var checkBalanceRepository: KISCheckBalanceRepository {
        DefaultKISCheckBalanceRepository(networkService: networkService)
    }
}

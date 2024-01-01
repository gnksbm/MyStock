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
        DIContainer.register(
            type: HomeChartUseCase.self,
            DefaultHomeChartPriceUseCase(
                oAuthRepository: oAuthRepository,
                chartPriceRepository: chartPriceRepository
            )
        )
    }
}

extension AppDelegate {
    var chartPriceRepository: KISChartPriceRepository {
        DefaultKISChartPriceRepository(networkService: networkService)
    }
    
    var oAuthRepository: KISOAuthRepository {
        DefaultKISOAuthRepository(networkService: networkService)
    }
    
    var checkBalanceRepository: KISCheckBalanceRepository {
        DefaultKISCheckBalanceRepository(networkService: networkService)
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

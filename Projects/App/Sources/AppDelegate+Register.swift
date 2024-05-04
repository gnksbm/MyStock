//
//  AppDelegate+Register.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

import Core
import CoreDataService
import Data
import Domain
import Networks

extension AppDelegate {
    func registerDependencies() {
        let networkService = DefaultNetworkService()
        let webSocketService = DefaultWebSocketService()
        let coreDataService = DefaultRxCoreDataService()
        
        DIContainer.register(
            type: FavoritesStockRepository.self,
            DefaultFavoritesStockRepository(coreDataService: coreDataService)
        )
        DIContainer.register(
            type: SearchStocksRepository.self,
            DefaultSearchStocksRepository()
        )
        DIContainer.register(
            type: KISChartPriceRepository.self,
            DefaultKISChartPriceRepository(networkService: networkService)
        )
        DIContainer.register(
            type: KISOAuthRepository.self,
            DefaultKISOAuthRepository(networkService: networkService)
        )
        DIContainer.register(
            type: KISCheckBalanceRepository.self,
            DefaultKISCheckBalanceRepository(networkService: networkService)
        )
        DIContainer.register(
            type: KISRealTimePriceRepository.self,
            DefualtKISRealTimePriceRepository(wsService: webSocketService)
        )
    }
}

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
        let networkService = DefaultNetworkService()
        let webSocketService = DefaultWebSocketService()
        let favoritesStockRepository = DefaultFavoritesStockRepository()
        let searchStocksRepository = DefaultSearchStocksRepository()
        let chartPriceRepository = DefaultKISChartPriceRepository(
            networkService: networkService
        )
        let oAuthRepository = DefaultKISOAuthRepository(
            networkService: networkService
        )
        let checkBalanceRepository = DefaultKISCheckBalanceRepository(
            networkService: networkService
        )
        let realTimePriceRepository = DefualtKISRealTimePriceRepository(
            wsService: webSocketService
        )
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
                chartPriceRepository: chartPriceRepository,
                realTimePriceRepository: realTimePriceRepository
            )
        )
        DIContainer.register(
            type: SearchStocksUseCase.self,
            DefaultSearchStocksUseCase(
                searchStocksRepository: searchStocksRepository,
                favoritesStockRepository: favoritesStockRepository
            )
        )
        DIContainer.register(
            type: FavoritesUseCase.self,
            DefaultFavoritesUseCase(
                favoritesStockRepository: favoritesStockRepository,
                searchStocksRepository: searchStocksRepository
            )
        )
    }
}

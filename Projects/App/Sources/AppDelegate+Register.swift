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
        DIContainer.register(
            type: CacheService.self,
            DefaultCacheService()
        )
        DIContainer.register(
            type: RxCoreDataService.self,
            DefaultRxCoreDataService()
        )
        DIContainer.register(
            type: NetworkService.self,
            DefaultNetworkService()
        )
        DIContainer.register(
            type: WebSocketService.self,
            DefaultWebSocketService()
        )
        DIContainer.register(
            type: LogoRepository.self,
            DefaultLogoRepository()
        )
        DIContainer.register(
            type: FavoritesStockRepository.self,
            DefaultFavoritesStockRepository()
        )
        DIContainer.register(
            type: SearchStocksRepository.self,
            DefaultSearchStocksRepository()
        )
        DIContainer.register(
            type: KISChartPriceRepository.self,
            DefaultKISChartPriceRepository()
        )
        DIContainer.register(
            type: KISOAuthRepository.self,
            DefaultKISOAuthRepository()
        )
        DIContainer.register(
            type: KISBalanceRepository.self,
            DefaultKISBalanceRepository()
        )
        DIContainer.register(
            type: KISRealTimePriceRepository.self,
            DefaultKISRealTimePriceRepository()
        )
        DIContainer.register(
            type: KISTopVolumeRepository.self,
            DefaultKISTopVolumeRepository()
        )
        DIContainer.register(
            type: KISTopMarketCapRepository.self,
            DefaultKISTopMarketCapRepository()
        )
    }
}

//
//  DefaultFavoritesStockRepository.swift
//  Data
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import CoreDataService
import Domain

import RxSwift
import RxCocoa

public final class DefaultFavoritesStockRepository: FavoritesStockRepository {
    @Injected private var coreDataService: RxCoreDataService
    
    public init() { }
    
    public func fetchFavorites() -> Observable<[FavoritesTicker]> {
        coreDataService.fetch(type: FavoritesTickerCoreDataModel.self)
            .map { 
                $0.map { $0.toDomain() } }
            .withUnretained(self)
            .map { repository, favoritesList in
                var deduplicateDic = [String: Int]()
                var result = [FavoritesTicker]()
                favoritesList.forEach { favorites in
                    if deduplicateDic[favorites.ticker] == nil {
                        deduplicateDic[favorites.ticker, default: 0] += 1
                        result.append(favorites)
                    } else {
                        _ = repository.coreDataService.delete(
                            data: favorites,
                            uniqueKeyPath: \.ticker
                        )
                    }
                }
                return result
            }
    }
    
    public func addFavorites(
        marketType: MarketType,
        ticker: String
    ) -> Observable<FavoritesTicker> {
        let newFavorites = FavoritesTicker(
            marketType: marketType,
            ticker: ticker
        ).toCoreDataObject()
        return coreDataService.saveUniqueData(
            data: newFavorites,
            uniqueKeyPath: \.ticker
        ).map { $0.toDomain() }
    }
    
    public func removeFavorites(
        marketType: MarketType,
        ticker: String
    ) -> Observable<FavoritesTicker> {
        let favoritesToRemove = FavoritesTicker(
            marketType: marketType,
            ticker: ticker
        ).toCoreDataObject()
        return coreDataService.delete(
            data: favoritesToRemove,
            uniqueKeyPath: \.ticker
        ).map { $0.toDomain() }
    }
}

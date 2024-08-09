//
//  FavoritesStockRepository.swift
//  Domain
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesStockRepository {
    func fetchFavorites() -> Observable<[FavoritesTicker]>
    func addFavorites(
        marketType: MarketType,
        ticker: String
    ) -> Observable<FavoritesTicker>
    func removeFavorites(
        marketType: MarketType,
        ticker: String
    ) -> Observable<FavoritesTicker>
}

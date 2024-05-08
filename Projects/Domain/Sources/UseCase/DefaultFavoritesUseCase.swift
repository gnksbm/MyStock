//
//  DefaultFavoritesUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultFavoritesUseCase: FavoritesUseCase {
    @Injected private var favoritesStockRepository: FavoritesStockRepository
    @Injected private var searchStocksRepository: SearchStocksRepository

    public init() { }
    
    public func fetchFavorites() -> Observable<[SearchStocksResponse]> {
        favoritesStockRepository.fetchFavorites()
            .withUnretained(self)
            .flatMap { useCase, favoritesList in
                Observable.zip(
                    favoritesList.map { favorites in
                        useCase.searchStocksRepository.searchStocks(
                            searchTerm: favorites.ticker
                        )
                    }
                )
            }
            .map { responses in
                responses.flatMap { $0 }
            }
    }
}

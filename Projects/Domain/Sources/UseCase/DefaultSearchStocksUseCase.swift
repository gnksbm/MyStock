//
//  DefaultSearchStocksUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core

import RxSwift

public final class DefaultSearchStocksUseCase: SearchStocksUseCase {
    @Injected private var searchStocksRepository: SearchStocksRepository
    @Injected private var favoritesStockRepository: FavoritesStockRepository
    
    public init() { }
    
    public func searchStocks(
        searchTerm: String
    ) -> Observable<[SearchStocksResponse]> {
        searchStocksRepository.searchStocks(searchTerm: searchTerm)
            .withLatestFrom(
                favoritesStockRepository.fetchFavorites()
            ) { searchResults, favoriteList in
                searchResults.map { item in
                    var copy = item
                    copy.isLiked = favoriteList.contains {
                        item.ticker == $0.ticker
                    }
                    return copy
                }
            }
    }
    
    public func updateFavorites(
        item: SearchStocksResponse
    ) -> Observable<SearchStocksResponse> {
        var result: Observable<FavoritesTicker>
        if item.isLiked {
            result = favoritesStockRepository.removeFavorites(
                ticker: item.ticker
            )
        } else {
            result = favoritesStockRepository.addFavorites(ticker: item.ticker)
        }
        return result.map { _ in
            var copy = item
            copy.isLiked.toggle()
            return copy
        }
    }
}

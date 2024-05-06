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
    @Injected(SearchStocksRepository.self)
    private var searchStocksRepository: SearchStocksRepository
    @Injected(FavoritesStockRepository.self)
    private var favoritesStockRepository: FavoritesStockRepository
    
    public init() { }
    
    public func searchStocks(
        searchTerm: String
    ) -> Observable<[SearchStocksResponse]> {
        searchStocksRepository.searchStocks(searchTerm: searchTerm)
    }
    
    public func addFavorites(ticker: String) -> Observable<FavoritesTicker> {
        favoritesStockRepository.addFavorites(ticker: ticker)
    }
}

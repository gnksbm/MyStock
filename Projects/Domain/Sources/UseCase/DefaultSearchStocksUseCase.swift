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
    @Injected(LogoRepository.self)
    private var logoRepository: LogoRepository
    
    public init() { }
    
    public func searchStocks(
        searchTerm: String
    ) -> Observable<[SearchStocksResponse]> {
        searchStocksRepository.searchStocks(searchTerm: searchTerm)
            .withUnretained(self)
            .flatMapLatest { useCase, stockList in
                guard !stockList.isEmpty
                else { return Observable.just([SearchStocksResponse]())}
                return Observable.zip(
                    stockList.map { stock in
                        useCase.logoRepository.fetchLogo(
                            request: .init(
                                ticker: stock.ticker,
                                marketType: stock.marketType
                            )
                        )
                        .catchAndReturn(
                            .init(
                                ticker: stock.ticker,
                                logo: nil
                            )
                        )
                    }
                )
                .map { logoList in
                    logoList.updateWithLogo(list: stockList)
                }
            }
    }
    
    public func addFavorites(ticker: String) -> Observable<FavoritesTicker> {
        favoritesStockRepository.addFavorites(ticker: ticker)
    }
}

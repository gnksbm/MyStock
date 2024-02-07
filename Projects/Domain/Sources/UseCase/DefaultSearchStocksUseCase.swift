//
//  DefaultSearchStocksUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultSearchStocksUseCase: SearchStocksUseCase {
    private let searchStocksRepository: SearchStocksRepository
    private let favoritesStockRepository: FavoritesStockRepository
    
    public let searchResult = PublishSubject<[SearchStocksResponse]>()
    private let disposeBag = DisposeBag()
    
    public init(
        searchStocksRepository: SearchStocksRepository,
        favoritesStockRepository: FavoritesStockRepository
    ) {
        self.searchStocksRepository = searchStocksRepository
        self.favoritesStockRepository = favoritesStockRepository
    }
    
    public func searchStocks(searchTerm: String) {
        searchStocksRepository.searchStocks(searchTerm: searchTerm)
            .withUnretained(self)
            .subscribe { useCase, results in
                useCase.searchResult.onNext(results)
            }
            .disposed(by: disposeBag)
    }
    
    public func addFavorites(ticker: String) {
        favoritesStockRepository.addFavorites(ticker: ticker)
    }
}

//
//  DefaultSearchStocksUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultSearchStocksUseCase: SearchStocksUseCase {
    @Injected(SearchStocksRepository.self)
    private var searchStocksRepository: SearchStocksRepository
    @Injected(FavoritesStockRepository.self)
    private var favoritesStockRepository: FavoritesStockRepository
    
    public let searchResult = PublishSubject<[SearchStocksResponse]>()
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    public func searchStocks(searchTerm: String) {
        searchStocksRepository.searchStocks(searchTerm: searchTerm)
            .withUnretained(self)
            .subscribe { useCase, results in
                useCase.searchResult.onNext(results)
            }
            .disposed(by: disposeBag)
    }
    
    public func addFavorites(ticker: String) throws {
        do {
            try favoritesStockRepository.addFavorites(ticker: ticker)
        } catch {
            throw error
        }
    }
}

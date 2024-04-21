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
    @Injected(FavoritesStockRepository.self)
    private var favoritesStockRepository: FavoritesStockRepository
    @Injected(SearchStocksRepository.self)
    private var searchStocksRepository: SearchStocksRepository

    public let favoritesStocks = BehaviorSubject<[SearchStocksResponse]>(
        value: []
    )
    private let disposeBag = DisposeBag()

    public init() { }
    
    public func fetchFavorites() {
        favoritesStockRepository.fetchFavorites()
        guard let favoritesTicker = try? favoritesStockRepository
            .favoritesTicker
            .value()
        else { return }
        Observable.combineLatest(
            favoritesTicker
                .map {
                    searchStocksRepository.searchStocks(searchTerm: $0)
                }
        )
        .map { response in
            response.flatMap { Set($0) }
        }
        .withUnretained(self)
        .subscribe(
            onNext: { useCase, respoense in
                useCase.favoritesStocks.onNext(respoense)
            }
        )
        .disposed(by: disposeBag)
    }
}

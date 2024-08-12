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
    @Injected 
    private var domesticPriceRepository: KISDomesticCurrentPriceRepository
    @Injected private var oAuthRepository: KISOAuthRepository
    @Injected private var favoritesStockRepository: FavoritesStockRepository
    @Injected private var searchStocksRepository: SearchStocksRepository
    
    @UserDefaultsWrapper(
        key: .userInfo,
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    public init() { }
    
    public func fetchFavorites() -> Observable<[KISCurrentPriceResponse]> {
        Observable.combineLatest(
            oAuthRepository.fetchToken(
                request: KISOAuthRequest(
                    oAuthType: .access,
                    investType: .reality
                )
            ),
            favoritesStockRepository.fetchFavorites()
        )
        .withUnretained(self)
        .flatMap { useCase, tuple in
            let (token, favoriteList) = tuple
            return Observable.from(favoriteList)
                    .filter { $0.marketType == .domestic }
                    .flatMap { favorite in
                        useCase.domesticPriceRepository.fetchCurrentPriceItem(
                            request: KISDomesticCurrentPriceRequest(
                                userInfo: useCase.userInfo,
                                token: token.token,
                                ticker: favorite.ticker,
                                marketDivision: .stockETFETN
                            )
                        )
                        .catch { error in
                            dump(error)
                            return .empty()
                        }
                    }
                    .toArray()
        }
        .withUnretained(self)
        .flatMap { useCase, items in
            Observable.from(items)
                .flatMap { item in
                    var copy = item
                    return useCase.searchStocksRepository.searchStocks(
                        searchTerm: item.ticker
                    )
                    .map { results in
                        if let name = results.first?.name {
                            copy.name = name
                        }
                        return copy
                    }
                }
                .toArray()
        }
    }
}

//
//  SearchStocksUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol SearchStocksUseCase {
    func searchStocks(searchTerm: String) -> Observable<[SearchStocksResponse]>
    func addFavorites(ticker: String) -> Observable<FavoritesTicker>
}

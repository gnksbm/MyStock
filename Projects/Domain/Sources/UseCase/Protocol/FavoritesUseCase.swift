//
//  FavoritesUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesUseCase {
    var favoritesStocks: BehaviorSubject<[SearchStocksResponse]> { get }
    
    func fetchFavorites()
}

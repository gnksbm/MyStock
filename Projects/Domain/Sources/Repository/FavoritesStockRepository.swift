//
//  FavoritesStockRepository.swift
//  Domain
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxRelay

public protocol FavoritesStockRepository {
    var favoritesTicker: BehaviorRelay<[String]> { get }
    
    func addFavorites(ticker: String)
}

//
//  FavoritesStockRepository.swift
//  Domain
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesStockRepository {
    var favoritesTicker: BehaviorSubject<[String]> { get }
    
    func addFavorites(ticker: String)
}

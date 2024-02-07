//
//  DefaultFavoritesStockRepository.swift
//  Data
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

import RxRelay

public final class DefaultFavoritesStockRepository: FavoritesStockRepository {
    public let favoritesTicker = BehaviorRelay<[String]>(value: [])
    
    public init() {
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        guard let savedFavorites = UserDefaults.standard.stringArray(
            forKey: "Favorites"
        )
        else { return }
        favoritesTicker.accept(savedFavorites)
    }
}

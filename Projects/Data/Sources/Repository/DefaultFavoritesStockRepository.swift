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
    
    private let favoritesKey = "Favorites"
    
    public init() {
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        guard let savedFavorites = UserDefaults.standard.stringArray(
            forKey: favoritesKey
        )
        else { return }
        favoritesTicker.accept(Array(Set(savedFavorites)))
    }
    
    public func addFavorites(ticker: String) {
        let updatedFavorites = Array(Set(favoritesTicker.value + [ticker]))
        UserDefaults.standard.setValue(updatedFavorites, forKey: favoritesKey)
        favoritesTicker.accept(updatedFavorites)
    }
}

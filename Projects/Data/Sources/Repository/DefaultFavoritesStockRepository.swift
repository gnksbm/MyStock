//
//  DefaultFavoritesStockRepository.swift
//  Data
//
//  Created by gnksbm on 2/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain
import CoreDataService

import RxRelay

public final class DefaultFavoritesStockRepository: FavoritesStockRepository {
    private let coreDataService: CoreDataService
    public let favoritesTicker = BehaviorRelay<[String]>(value: [])
    
    private let favoritesKey = "Favorites"
    
    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
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

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

import RxSwift

public final class DefaultFavoritesStockRepository: FavoritesStockRepository {
    private let coreDataService: CoreDataService
    public let favoritesTicker = BehaviorSubject<[String]>(value: [])
    
    private let favoritesKey = "Favorites"
    
    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        do {
            let savedFavorites = try coreDataService.fetch(
                type: FavoritesTicker.self
            )
            favoritesTicker.onNext(savedFavorites.map { $0.ticker })
        } catch {
            favoritesTicker.onError(error)
        }
    }
    
    public func addFavorites(ticker: String) {
        coreDataService.save(data: FavoritesTicker(ticker: ticker))
        fetchFavorites()
    }
}

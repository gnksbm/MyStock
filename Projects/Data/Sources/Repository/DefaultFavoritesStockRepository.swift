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
    
    public init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    public func fetchFavorites() {
        do {
            let savedFavorites = try coreDataService.fetch(
                type: FavoritesTicker.self
            ).map { $0.ticker }
            let duplicationRemoved = Array(Set(savedFavorites))
            favoritesTicker.onNext(duplicationRemoved)
        } catch {
            favoritesTicker.onError(error)
        }
    }
    
    public func addFavorites(ticker: String) throws {
        let data = FavoritesTicker(ticker: ticker)
        do {
            let status = try coreDataService.duplicationCheck(
                data: data,
                uniqueKeyPath: \.ticker
            )
            guard status != .duplicated 
            else {
                print("Data is Duplicated")
                return
            }
            do {
                try coreDataService.save(
                    data: data
                )
                fetchFavorites()
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    public func removeFavorites(ticker: String) throws {
        do {
            try coreDataService.delete(
                data: FavoritesTicker(
                    ticker: ticker
                ),
                uniqueKeyPath: \.ticker
            )
            fetchFavorites()
        } catch {
            throw error
        }
    }
}

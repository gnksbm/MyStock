//
//  FavoritesTicker.swift
//  Domain
//
//  Created by gnksbm on 2/18/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import CoreData

public struct FavoritesTicker: CoreDataStorable {
    public let marketType: MarketType
    public let ticker: String
    
    public init(
        marketType: MarketType,
        ticker: String
    ) {
        self.marketType = marketType
        self.ticker = ticker
    }
}

public extension FavoritesTicker {
    func toCoreDataObject() -> FavoritesTickerCoreDataModel {
        FavoritesTickerCoreDataModel(
            marketType: marketType.rawValue,
            ticker: ticker
        )
    }
}

public struct FavoritesTickerCoreDataModel: CoreDataStorable {
    public let marketType: Int64
    public let ticker: String
    
    public init(
        marketType: Int64,
        ticker: String
    ) {
        self.marketType = marketType
        self.ticker = ticker
    }
}

extension FavoritesTickerCoreDataModel {
    public func toDomain() -> FavoritesTicker {
        FavoritesTicker(
            marketType: MarketType(rawValue: marketType)!,
            ticker: ticker
        )
    }
}

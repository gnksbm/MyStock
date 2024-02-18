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

public struct FavoritesTicker: Storable {
    public static let coreDataType: EntityRepresentable.Type 
= FavoritesTickerEntity.self
    
    let ticker: String
}

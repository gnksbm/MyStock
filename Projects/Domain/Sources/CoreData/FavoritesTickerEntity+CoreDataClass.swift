//
//  FavoritesTickerMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

import Core

@objc(FavoritesTickerEntity)
public class FavoritesTickerMO: NSManagedObject, CoreDataModelObject {
    public var toEntity: Storable {
        guard let ticker else { fatalError("Ticker is non-optional") }
        return FavoritesTicker(ticker: ticker)
    }
}

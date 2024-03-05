//
//  FavoritesTickerMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/26/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(FavoritesTickerMO)
public class FavoritesTickerMO: NSManagedObject, CoreDataModelObject {
    
    public var toDomain: CoreDataStorable {
        guard let ticker
        else { fatalError("Ticker is non-optional") }
        return FavoritesTicker(
            ticker: ticker
        )
    }
}

//
//  FavoritesTickerCoreDataModelMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/26/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(FavoritesTickerCoreDataModelMO)
public class FavoritesTickerCoreDataModelMO:
    NSManagedObject, CoreDataModelObject {
    public var toDomain: CoreDataStorable {
        guard let ticker
        else { fatalError("Ticker is non-optional") }
        return FavoritesTickerCoreDataModel(
            marketType: marketType,
            ticker: ticker
        )
    }
}

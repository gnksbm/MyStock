//
//  FavoritesTickerCoreDataModelMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 8/9/24.
//
//

import Foundation
import CoreData

extension FavoritesTickerCoreDataModelMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesTickerCoreDataModelMO> {
        return NSFetchRequest<FavoritesTickerCoreDataModelMO>(
            entityName: "FavoritesTickerCoreDataModelMO"
        )
    }

    @NSManaged public var ticker: String?
    @NSManaged public var marketType: Int64
}

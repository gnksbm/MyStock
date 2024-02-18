//
//  FavoritesTickerEntity+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

extension FavoritesTickerEntity {

    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesTickerEntity> {
        return NSFetchRequest<FavoritesTickerEntity>(
            entityName: "FavoritesTickerEntity"
        )
    }

    @NSManaged public var ticker: String?

}

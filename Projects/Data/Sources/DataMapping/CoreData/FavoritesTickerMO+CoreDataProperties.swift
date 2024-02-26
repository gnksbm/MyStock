//
//  FavoritesTickerMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/26/24.
//
//

import Foundation
import CoreData

extension FavoritesTickerMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesTickerMO> {
        return NSFetchRequest<FavoritesTickerMO>(
            entityName: "FavoritesTickerMO"
        )
    }

    @NSManaged public var ticker: String?
}

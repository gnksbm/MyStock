//
//  FavoritesTickerMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

extension FavoritesTickerMO {

    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesTickerMO> {
        return NSFetchRequest<FavoritesTickerMO>(
            entityName: "FavoritesTickerEntity"
        )
    }

    @NSManaged public var ticker: String?

}

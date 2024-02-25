//
//  KISOAuthTokenMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

extension KISOAuthTokenMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<KISOAuthTokenMO> {
        return NSFetchRequest<KISOAuthTokenMO>(
            entityName: "KISOAuthTokenEntity"
        )
    }

    @NSManaged public var token: String?
    @NSManaged public var expireDate: Date?

}

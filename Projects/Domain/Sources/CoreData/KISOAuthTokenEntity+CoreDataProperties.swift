//
//  KISOAuthTokenEntity+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

extension KISOAuthTokenEntity {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<KISOAuthTokenEntity> {
        return NSFetchRequest<KISOAuthTokenEntity>(
            entityName: "KISOAuthTokenEntity"
        )
    }

    @NSManaged public var token: String?
    @NSManaged public var expireDate: Date?

}

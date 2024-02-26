//
//  KISOAuthTokenMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/26/24.
//
//

import Foundation
import CoreData

extension KISOAuthTokenMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<KISOAuthTokenMO> {
        return NSFetchRequest<KISOAuthTokenMO>(entityName: "KISOAuthTokenMO")
    }

    @NSManaged public var expireDate: Date?
    @NSManaged public var token: String?
}

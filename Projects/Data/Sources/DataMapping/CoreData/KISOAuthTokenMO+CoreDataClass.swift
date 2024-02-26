//
//  KISOAuthTokenMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/26/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(KISOAuthTokenMO)
public class KISOAuthTokenMO: NSManagedObject, CoreDataModelObject {
    public var toEntity: CoreDataStorable {
        guard let token,
              let expireDate
        else { fatalError("Ticker is non-optional") }
        return KISOAuthToken(
            token: token,
            expireDate: expireDate
        )
    }
}

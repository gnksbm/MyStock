//
//  KISOAuthTokenMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/18/24.
//
//

import Foundation
import CoreData

import Core

@objc(KISOAuthTokenEntity)
public class KISOAuthTokenMO: NSManagedObject, CoreDataModelObject {

    public var toEntity: Storable {
        guard let token,
              let expireDate
        else { fatalError("Ticker is non-optional") }
        return KISOAuthToken(
            token: token,
            expireDate: expireDate
        )
    }
}

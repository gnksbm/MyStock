//
//  Storable.swift
//  Core
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import CoreData

public protocol Storable {
    static var coreDataType: NSManagedObject.Type { get }
}

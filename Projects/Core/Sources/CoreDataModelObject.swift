//
//  CoreDataModelObject.swift
//  Core
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation
import CoreData

public protocol CoreDataModelObject: NSManagedObject {
    var toEntity: CoreDataStorable { get }
}

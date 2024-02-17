//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

public protocol CoreDataService {
    func fetch(type: Storable.Type) throws -> [Storable]
    func save(data: Storable)
    func update(data: Storable)
    func delete(data: Storable)
}

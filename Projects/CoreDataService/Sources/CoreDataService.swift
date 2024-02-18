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
    func fetch(type: any Storable.Type) throws -> [any Storable]
    func save(data: any Storable)
    func update(data: any Storable)
    func delete(data: any Storable)
}

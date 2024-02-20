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
    func fetch<T: Storable>(type: T.Type) throws -> [T]
    func save(data: some Storable)
    func update(data: some Storable)
    func delete(data: some Storable)
}

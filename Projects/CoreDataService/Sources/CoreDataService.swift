//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol CoreDataService {
    func fetch<T>(type: T.Type)
    func save<T>(data: T)
    func update<T>(data: T)
    func delete<T>(data: T)
}

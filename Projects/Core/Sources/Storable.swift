//
//  Storable.swift
//  Core
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol Storable {
    static var coreDataType: EntityRepresentable.Type { get }
}

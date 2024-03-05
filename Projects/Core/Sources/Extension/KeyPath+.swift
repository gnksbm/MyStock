//
//  KeyPath+.swift
//  Core
//
//  Created by gnksbm on 3/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public extension KeyPath {
    var propertyName: String {
        guard let propertyName = String(describing: self)
            .components(separatedBy: ".")
            .last
        else { fatalError(#function) }
        return propertyName
    }
}

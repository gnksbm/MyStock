//
//  Dictionary+.swift
//  Core
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public extension Dictionary {
    func merging(@TypeBuilder<Dictionary> _ others: () -> [Self]) -> Self {
        var copy = self
        others().forEach { copy.merge($0) { $1 } }
        return copy
    }
}

//
//  Double+.swift
//  Core
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public extension Double {
    var removeDecimal: any Numeric {
        if self == Double(Int(self)) {
            return Int(self)
        } else {
            return self
        }
    }
}

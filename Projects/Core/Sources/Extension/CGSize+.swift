//
//  CGSize+.swift
//  Core
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public extension CGSize {
    static func same(length: CGFloat) -> Self {
        CGSize(width: length, height: length)
    }
}

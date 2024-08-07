//
//  NSDirectionalEdgeInsets+.swift
//  Core
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension NSDirectionalEdgeInsets {
    static func same(inset: CGFloat) -> Self {
        NSDirectionalEdgeInsets(
            top: inset,
            leading: inset,
            bottom: inset,
            trailing: inset
        )
    }
}

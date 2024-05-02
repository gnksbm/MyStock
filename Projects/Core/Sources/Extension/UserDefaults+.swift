//
//  UserDefaults+.swift
//  Core
//
//  Created by gnksbm on 5/2/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public extension UserDefaults {
    static let appGroup = UserDefaults(
        suiteName: "group.com.GeonSeobKim.KISStock"
    ) ?? .standard
}

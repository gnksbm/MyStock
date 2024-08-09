//
//  MarketType.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public enum MarketType: Int64, CaseIterable {
    case overseas, domestic
    
    public var toString: String {
        switch self {
        case .overseas:
            "해외 주식"
        case .domestic:
            "국내 주식"
        }
    }
}

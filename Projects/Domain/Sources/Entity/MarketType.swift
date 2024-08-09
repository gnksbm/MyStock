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
    
    public var chartPricePath: String {
        let path1 = "/uapi/"
        var path2: String
        let path3 = "/v1/quotations/inquire-daily-"
        var path4: String
        switch self {
        case .overseas:
            path2 = "overseas-price"
            path4 = "chartprice"
        case .domestic:
            path2 = "domestic-stock"
            path4 = "itemchartprice"
        }
        return path1 + path2 + path3 + path4
    }
}

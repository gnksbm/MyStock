//
//  KISRealTimePriceRequest.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISRealTimePriceRequest {
    let approvalKey: String
    let ticker: String
    let investType: InvestType
    let marketType: MarketType
}

//
//  KISRealTimePriceRequest.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISRealTimePriceRequest {
    public let approvalKey: String
    public let ticker: String
    public let investType: InvestType
    public let marketType: MarketType
    
    public init(
        approvalKey: String,
        ticker: String,
        investType: InvestType,
        marketType: MarketType
    ) {
        self.approvalKey = approvalKey
        self.ticker = ticker
        self.investType = investType
        self.marketType = marketType
    }
}

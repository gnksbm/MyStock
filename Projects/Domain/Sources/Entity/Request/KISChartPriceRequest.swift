//
//  KISChartPriceRequest.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISChartPriceRequest {
    public let investType: InvestType
    public let marketType: MarketType
    public let period: PeriodType
    public let ticker: String
    public let startDate: String // "20231231"
    public let endDate: String // "20231231"
    public let authorization: String
    
    public init(
        investType: InvestType,
        marketType: MarketType,
        period: PeriodType,
        ticker: String,
        startDate: String,
        endDate: String,
        authorization: String
    ) {
        self.investType = investType
        self.marketType = marketType
        self.period = period
        self.ticker = ticker
        self.startDate = startDate
        self.endDate = endDate
        self.authorization = authorization
    }
}

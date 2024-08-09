//
//  KISDailyChartPriceRequest.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct KISDailyChartPriceRequest {
    public let ticker: String
    public let token: String
    public let userInfo: KISUserInfo
    public let authorization: String
    public var quries: [KISQueryRepresentable] {
        [
            KISMarketDivisionCode.stockETFETN,
            KISInputISCode.ticker(ticker)
        ]
    }
    
    public init(
        ticker: String,
        token: String,
        userInfo: KISUserInfo,
        authorization: String
    ) {
        self.ticker = ticker
        self.token = token
        self.userInfo = userInfo
        self.authorization = authorization
    }
}

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
    public var quries: [KISQueryRepresentable] {
        [
            KISMarketDivisionCode.stockETFETN,
            KISInputISCode.ticker(ticker)
        ]
    }
    
    public init(
        ticker: String,
        token: String,
        userInfo: KISUserInfo
    ) {
        self.ticker = ticker
        self.token = token
        self.userInfo = userInfo
    }
}

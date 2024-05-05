//
//  LogoRequest.swift
//  Domain
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct LogoRequest {
    public let ticker: String
    public let marketType: MarketType
    
    public init(
        ticker: String,
        marketType: MarketType
    ) {
        self.ticker = ticker
        self.marketType = marketType
    }
}

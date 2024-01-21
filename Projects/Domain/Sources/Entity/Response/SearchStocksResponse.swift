//
//  SearchStocksResponse.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct SearchStocksResponse {
    public let ticker: String
    public let name: String
    public let marketType: MarketType
    
    public init(
        ticker: String,
        name: String,
        marketType: MarketType
    ) {
        self.ticker = ticker
        self.name = name
        self.marketType = marketType
    }
}

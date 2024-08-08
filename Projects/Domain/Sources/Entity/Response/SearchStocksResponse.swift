//
//  SearchStocksResponse.swift
//  Domain
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public struct SearchStocksResponse: Hashable, LogoNecessary {
    public var image: UIImage?
    public let ticker: String
    public let name: String
    public let marketType: MarketType
    public var isLiked = false
    
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

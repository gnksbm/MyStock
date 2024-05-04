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
    public let markeyType: MarketType
    
    public init(
        ticker: String,
        markeyType: MarketType
    ) {
        self.ticker = ticker
        self.markeyType = markeyType
    }
}

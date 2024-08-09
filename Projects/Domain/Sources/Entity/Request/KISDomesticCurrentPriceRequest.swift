//
//  KISDomesticCurrentPriceRequest.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct KISDomesticCurrentPriceRequest {
    public let userInfo: KISUserInfo
    public let token: String
    public let ticker: String
    public let marketDivision: KISMarketDivisionCode
    public var queryHeader: [KISQueryRepresentable] {
        [
            KISInputISCode.ticker(ticker)
        ] + [marketDivision]
    }
}

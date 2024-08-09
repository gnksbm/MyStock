//
//  KISDailyChartPriceResponse.swift
//  Domain
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core

public struct KISDailyChartPriceResponse { 
    public let image: UIImage?
    public let name: String
    public let price: String
    public let fluctuationRate: String
    public let ticker: String
    public let volume: String
    public let candles: [CandlestickRepresentable]
    
    public var openingPrice: String? {
        guard let openingPrice = candles.chartOpeingPrice else { return nil }
        return "\(openingPrice)"
    }
    public var highPrice: String? {
        guard let highPrice = candles.chartHighest else { return nil }
        return "\(highPrice)"
    }
    public var lowPrice: String? {
        guard let lowPrice = candles.chartLowest else { return nil }
        return "\(lowPrice)"
    }
    
    public init(
        image: UIImage? = nil,
        name: String,
        price: String,
        fluctuationRate: String,
        ticker: String,
        volume: String,
        candles: [CandlestickRepresentable]
    ) {
        self.image = image
        self.price = price
        self.name = name
        self.fluctuationRate = fluctuationRate
        self.ticker = ticker
        self.volume = volume
        self.candles = candles
    }
}

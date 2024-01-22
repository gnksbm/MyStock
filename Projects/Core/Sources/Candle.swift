//
//  Candle.swift
//  Core
//
//  Created by gnksbm on 2024/01/01.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct Candle: Equatable {
    public let date: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    
    public init(
        date: String,
        open: Double,
        low: Double,
        high: Double,
        close: Double
    ) {
        self.date = date.toDate(dateFormat: "yyyyMMdd")
        self.open = open
        self.low = low
        self.high = high
        self.close = close
    }
    
    public init?(
        date: String,
        open: String,
        low: String,
        high: String,
        close: String
    ) {
        guard let open = Double(open),
                let low = Double(low),
                let high = Double(high),
                let close = Double(close)
        else { return nil }
        self.date = date.toDate(dateFormat: "yyyyMMdd")
        self.open = open
        self.low = low
        self.high = high
        self.close = close
    }
}

public extension [Candle] {
    var highestPrice: Double {
        var highestPrice = 0.0
        forEach { candle in
            if candle.high > highestPrice {
                highestPrice = candle.high
            }
        }
        return highestPrice
    }
    
    var lowestPrice: Double {
        guard let first = first?.low else {
            return 0
        }
        var lowestPrice = first
        forEach { candle in
            if candle.low < lowestPrice {
                lowestPrice = candle.low
            }
        }
        return lowestPrice
    }
}

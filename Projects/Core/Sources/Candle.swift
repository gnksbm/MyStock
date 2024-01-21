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
    public let startPrice: Double
    public let lowestPrice: Double
    public let highestPrice: Double
    public let closePrice: Double
    
    public init(
        date: String,
        startPrice: Double,
        lowestPrice: Double,
        highestPrice: Double,
        closePrice: Double
    ) {
        self.date = date.toDate(dateFormat: "yyyyMMdd")
        self.startPrice = startPrice
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
        self.closePrice = closePrice
    }
    
    public init?(
        date: String,
        startPrice: String,
        lowestPrice: String,
        highestPrice: String,
        closePrice: String
    ) {
        guard let startPrice = Double(startPrice),
                let lowestPrice = Double(lowestPrice),
                let highestPrice = Double(highestPrice),
                let closePrice = Double(closePrice)
        else { return nil }
        self.date = date.toDate(dateFormat: "yyyyMMdd")
        self.startPrice = startPrice
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
        self.closePrice = closePrice
    }
}

public extension [Candle] {
    var highestPrice: Double {
        var highestPrice = 0.0
        forEach { candle in
            if candle.highestPrice > highestPrice {
                highestPrice = candle.highestPrice
            }
        }
        return highestPrice
    }
    
    var lowestPrice: Double {
        guard let first = first?.lowestPrice else {
            return 0
        }
        var lowestPrice = first
        forEach { candle in
            if candle.lowestPrice < lowestPrice {
                lowestPrice = candle.lowestPrice
            }
        }
        return lowestPrice
    }
}

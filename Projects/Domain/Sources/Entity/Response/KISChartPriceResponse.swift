//
//  KISChartPriceResponse.swift
//  Domain
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct KISChartPriceResponse: CandlestickRepresentable, Equatable {
    public let date: Date
    public let openingPrice: Price
    public let highestPrice: Price
    public let lowestPrice: Price
    public let closingPrice: Price
    
    public init(
        date: Date,
        openingPrice: Price,
        highestPrice: Price,
        lowestPrice: Price,
        closingPrice: Price
    ) {
        self.date = date
        self.openingPrice = openingPrice
        self.highestPrice = highestPrice
        self.lowestPrice = lowestPrice
        self.closingPrice = closingPrice
    }
    
    public init?(
        date: String,
        openingPrice: String,
        highestPrice: String,
        lowestPrice: String,
        closingPrice: String
    ) {
        guard let openingPrice = Double(openingPrice),
              let highestPrice = Double(highestPrice),
              let lowestPrice = Double(lowestPrice),
              let closingPrice = Double(closingPrice)
        else { return nil }
        self.date = date.toDate(dateFormat: "yyyyMMdd")
        self.openingPrice = openingPrice
        self.highestPrice = highestPrice
        self.lowestPrice = lowestPrice
        self.closingPrice = closingPrice
    }
}

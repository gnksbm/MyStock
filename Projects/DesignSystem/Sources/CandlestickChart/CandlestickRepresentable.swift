//
//  CandlestickRepresentable.swift
//  DesignSystem
//
//  Created by gnksbm on 5/3/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol CandlestickRepresentable {
    typealias Price = Double
    
    var date: Date { get }
    var openingPrice: Price { get }
    var highestPrice: Price { get }
    var lowestPrice: Price { get }
    var closingPrice: Price { get }
}

extension CandlestickRepresentable {
    var dailyRange: Price {
        highestPrice - lowestPrice
    }
    
    var fluctuation: Price {
        openingPrice - closingPrice
    }
    
    var candleKind: CandleKind {
        switch -fluctuation {
        case ..<0:
            return .black
        case 0:
            return .dodge
        default:
            return .white
        }
    }
}

extension Array<CandlestickRepresentable> {
    var chartHighest: Element.Price? {
        self.lazy.map { $0.highestPrice }.max()
    }
    
    var chartLowest: Element.Price? {
        self.lazy.map { $0.lowestPrice }.min()
    }
}

//
//  CandleShape.swift
//  DesignSystem
//
//  Created by gnksbm on 2024/01/01.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI

import Core

public struct CandleShape {
    private let viewHeight: CGFloat
    private let viewWidth: CGFloat
    private let highestPrice: CGFloat
    private let lowestPrice: CGFloat
    private let totalCandleCount: CGFloat
    private let candle: Candle
    
    init(
        viewHeight: CGFloat,
        viewWidth: CGFloat,
        highestPrice: CGFloat,
        lowestPrice: CGFloat,
        totalCandleCount: CGFloat,
        candle: Candle
    ) {
        self.viewHeight = viewHeight
        self.highestPrice = highestPrice
        self.lowestPrice = lowestPrice
        self.viewWidth = viewWidth
        self.totalCandleCount = totalCandleCount
        self.candle = candle
    }
}

// MARK: Internal

extension CandleShape {
    var candleColor: UIColor {
        candleType.color
    }
    
    func getFrame(_ type: ViewType, heightRatio: Double = 0.8) -> CGRect {
        let startPoint = (1 - heightRatio) / 2 * viewHeight
        return .init(
            x: getX(type),
            y: getY(type) * heightRatio + startPoint,
            width: getWidth(type),
            height: getHeight(type) * heightRatio
        )
    }
    
    enum ViewType {
        case tail, body
    }
}

// MARK: Private
// MARK: Common

extension CandleShape {
    private var startPoint: CGFloat {
        let price = highestPrice - candle.startPrice
        return priceToPoint(price: price)
    }
    
    private var closePoint: CGFloat {
        let price = highestPrice - candle.closePrice
        print(highestPrice)
        print(candle.closePrice)
        return priceToPoint(price: price)
    }
    
    private var candleType: CandleType {
        if candle.closePrice > candle.startPrice {
            return .white
        } else if candle.closePrice == candle.startPrice {
            return .dodge
        } else {
            return .black
        }
    }
    
    private func priceToPoint(price: CGFloat) -> CGFloat {
        let priceRange = highestPrice - lowestPrice
        return price / priceRange * viewHeight
    }
    
    private enum CandleType {
        case white, dodge, black
        
        var color: UIColor {
            switch self {
            case .white:
                return DesignSystemAsset.whiteCandle.color
            case .dodge:
                return .gray
            case .black:
                return DesignSystemAsset.blackCandle.color
            }
        }
    }
}

// MARK: Tail

extension CandleShape {
    private var tailHeight: CGFloat {
        let price = candle.highestPrice - candle.lowestPrice
        return priceToPoint(price: price)
    }
    
    private var tailY: CGFloat {
        let price = highestPrice - candle.highestPrice
        return priceToPoint(price: price)
    }
}

// MARK: Body

extension CandleShape {
    private var bodyHeight: CGFloat {
        switch candleType {
        case .white:
            return startPoint - closePoint
        case .dodge:
            return 1
        case .black:
            return closePoint - startPoint
        }
    }
    
    private var bodyY: CGFloat {
        switch candleType {
        case .white:
            return closePoint
        case .dodge:
            return startPoint
        case .black:
            return startPoint
        }
    }
}

// MARK: Frame

extension CandleShape {
    private func getX(_ type: ViewType) -> CGFloat {
        switch type {
        case .body:
            return 0
        case .tail:
            return viewWidth / totalCandleCount * 0.9 / 2
        }
    }
    
    private func getY(_ type: ViewType) -> CGFloat {
        switch type {
        case .tail:
            return tailY
        case .body:
            return bodyY
        }
    }
    
    private func getHeight(_ type: ViewType) -> CGFloat {
        switch type {
        case .tail:
            return tailHeight
        case .body:
            return bodyHeight
        }
    }
    
    private func getWidth(_ type: ViewType) -> CGFloat {
        switch type {
        case .body:
            return viewWidth / totalCandleCount * 0.9
        case .tail:
            return 1
        }
    }
}

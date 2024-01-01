//
//  CandleShape.swift
//  DesignSystem
//
//  Created by gnksbm on 2024/01/01.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI

import Core

extension CandleChartView {
    struct CandleShape {
        let viewMinHeight: CGFloat
        let viewMaxHeight: CGFloat
        let highestPrice: CGFloat
        let lowestPrice: CGFloat
        let maxWidth: CGFloat
        let totalCandleCount: CGFloat
        let candle: Candle
        
        var candleTailHeight: CGFloat {
            convertViewPoint(distance: candle.highestPrice - candle.lowestPrice)
        }
        
        var candleTailOffset: CGFloat {
            tailTopPoint + candleTailHeight / 2
        }
        
        var candleBodyHeight: CGFloat {
            switch candleType {
            case .white:
                return whiteCandleHeight
            case .dodge:
                return 0
            case .black:
                return blackCandleHeight
            }
        }
        
        var candleBodyOffset: CGFloat {
            switch candleType {
            case .white:
                return whiteCandleOffset
            case .dodge:
                return dodgeCandleOffset
            case .black:
                return blackCandleOffset
            }
        }
        
        var dodgeCandleOffset: CGFloat {
            dodgeCandleTopPoint
        }
        
        var candleColor: Color {
            candleType.color
        }
        
        private var tailTopPoint: CGFloat {
            let distance = highestPrice - candle.highestPrice
            return convertViewPoint(distance: distance)
        }
        
        private var whiteCandleTopPoint: CGFloat {
            let whiteCandleTopDistance = highestPrice - candle.closePrice
            return convertViewPoint(distance: whiteCandleTopDistance)
        }
        
        private var whiteCandleHeight: CGFloat {
            dodgeCandleTopPoint - whiteCandleTopPoint
        }
        
        private var whiteCandleOffset: CGFloat {
            whiteCandleTopPoint + whiteCandleHeight / 2
        }
        
        private var dodgeCandleTopPoint: CGFloat {
            let distance = highestPrice - candle.startPrice
            return convertViewPoint(distance: distance)
        }
        
        private var blackCandleTopPoint: CGFloat {
            let distance = highestPrice - candle.closePrice
            return convertViewPoint(distance: distance)
        }
        
        private var blackCandleHeight: CGFloat {
            blackCandleTopPoint - dodgeCandleTopPoint
        }
        
        private var blackCandleOffset: CGFloat {
            blackCandleTopPoint - blackCandleHeight / 2
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
        
        private func convertViewPoint(distance: CGFloat) -> CGFloat {
            let priceRange = highestPrice - lowestPrice
            let viewRange = viewMaxHeight - viewMinHeight
            return distance / priceRange * viewRange
        }
        
        private enum CandleType {
            case white, dodge, black
            
            var color: Color {
                switch self {
                case .white:
                    return .red
                case .dodge:
                    return .gray
                case .black:
                    return .blue
                }
            }
        }
    }
}

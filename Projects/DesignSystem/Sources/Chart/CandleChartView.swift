//
//  CandleChartView.swift
//  DesignSystem
//
//  Created by gnksbm on 2023/12/31.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import SwiftUI

import Core

public struct CandleChartView: View {
    let candles: [Candle]
    
    public var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(
                    candles.sorted(by: { $0.date < $1.date }),
                    id: \.date
                ) { candle in
                    let shape = CandleShape(
                        viewMinHeight: proxy.frame(in: .global).minY,
                        viewMaxHeight: proxy.frame(in: .global).maxY,
                        highestPrice: highestPrice,
                        lowestPrice: lowestPrice,
                        maxWidth: proxy.frame(in: .global).width,
                        totalCandleCount: candles.count.f,
                        candle: candle
                    )
                    Rectangle()
                        .frame(height: 1)
                        .offset(y: shape.dodgeCandleOffset)
                        .overlay {
                            candleTail(shape: shape)
                            candleBody(shape: shape)
                        }
                        .foregroundColor(shape.candleColor)
                        .padding(.horizontal, 1)
                }
            }
        }
    }
    
    var highestPrice: Double {
        var highestPrice = 0.0
        candles.forEach { candle in
            if candle.highestPrice > highestPrice {
                highestPrice = candle.highestPrice
            }
        }
        return highestPrice
    }
    
    var lowestPrice: Double {
        guard let first = candles.first?.lowestPrice else {
            print("nil")
            return 0
        }
        var lowestPrice = highestPrice
        candles.forEach { candle in
            if candle.lowestPrice < lowestPrice {
                lowestPrice = candle.lowestPrice
            }
        }
        return lowestPrice
    }
    
    public init(candles: [Candle]) {
        self.candles = candles
    }
    
    func candleTail(shape: CandleShape) -> some View {
        Rectangle()
            .frame(
                width: 1,
                height: shape.candleTailHeight
            )
            .offset(y: shape.candleTailOffset)
    }
    
    func candleBody(shape: CandleShape) -> some View {
        Rectangle()
            .frame(
                height: shape.candleBodyHeight
            )
            .offset(y: shape.candleBodyOffset)
    }
}

struct KISChartView_Previews: PreviewProvider {
    static var previews: some View {
        CandleChartView(candles: .mock)
    }
}

extension Array<Candle> {
    static let mock: Self = [
        Candle(date: "20231227",
               startPrice: 224000.0,
               lowestPrice: 221000.0,
               highestPrice: 224000.0,
               closePrice: 224000.0),
        Candle(
            date: "20231226",
            startPrice: 216000.0,
            lowestPrice: 215500.0,
            highestPrice: 223000.0,
            closePrice: 223000.0),
        Candle(date: "20231225",
               startPrice: 216500.0,
               lowestPrice: 215000.0,
               highestPrice: 217500.0,
               closePrice: 215500.0),
        Candle(date: "20231221",
               startPrice: 218500.0,
               lowestPrice: 215000.0,
               highestPrice: 219000.0,
               closePrice: 215000.0),
        Candle(date: "20231220",
               startPrice: 218500.0,
               lowestPrice: 215500.0,
               highestPrice: 220000.0,
               closePrice: 216500.0),
        Candle(date: "20231219",
               startPrice: 224000.0,
               lowestPrice: 219500.0,
               highestPrice: 225500.0,
               closePrice: 220500.0),
        Candle(date: "20231218",
               startPrice: 222500.0,
               lowestPrice: 221000.0,
               highestPrice: 224500.0,
               closePrice: 222500.0),
        Candle(date: "20231217",
               startPrice: 226000.0,
               lowestPrice: 222000.0,
               highestPrice: 226500.0,
               closePrice: 223000.0),
        Candle(date: "20231214",
               startPrice: 223000.0,
               lowestPrice: 222000.0,
               highestPrice: 226500.0,
               closePrice: 226000.0),
        Candle(date: "20231213",
               startPrice: 218500.0,
               lowestPrice: 217000.0,
               highestPrice: 225000.0,
               closePrice: 223000.0),
        Candle(date: "20231212",
               startPrice: 212000.0,
               lowestPrice: 212000.0,
               highestPrice: 215500.0,
               closePrice: 213500.0),
        Candle(date: "20231211",
               startPrice: 216500.0,
               lowestPrice: 212500.0,
               highestPrice: 219500.0,
               closePrice: 213500.0),
        Candle(date: "20231210",
               startPrice: 218500.0,
               lowestPrice: 215000.0,
               highestPrice: 220500.0,
               closePrice: 217500.0),
        Candle(date: "20231207",
               startPrice: 215500.0,
               lowestPrice: 215000.0,
               highestPrice: 219000.0,
               closePrice: 217500.0),
        Candle(date: "20231206",
               startPrice: 214000.0,
               lowestPrice: 210000.0,
               highestPrice: 215000.0,
               closePrice: 212500.0),
        Candle(date: "20231205",
               startPrice: 214000.0,
               lowestPrice: 212500.0,
               highestPrice: 215500.0,
               closePrice: 213500.0),
        Candle(date: "20231204",
               startPrice: 210000.0,
               lowestPrice: 209500.0,
               highestPrice: 216500.0,
               closePrice: 213000.0),
        Candle(date: "20231203",
               startPrice: 208000.0,
               lowestPrice: 207500.0,
               highestPrice: 214000.0,
               closePrice: 210500.0),
        Candle(date: "20231130",
               startPrice: 208000.0,
               lowestPrice: 204000.0,
               highestPrice: 210000.0,
               closePrice: 206000.0),
        Candle(date: "20231129",
               startPrice: 206500.0,
               lowestPrice: 206500.0,
               highestPrice: 209500.0,
               closePrice: 208000.0),
        Candle(date: "20231128",
               startPrice: 208500.0,
               lowestPrice: 205500.0,
               highestPrice: 209000.0,
               closePrice: 207500.0),
        Candle(date: "20231127",
               startPrice: 208000.0,
               lowestPrice: 204500.0,
               highestPrice: 210000.0,
               closePrice: 207500.0),
        Candle(date: "20231126",
               startPrice: 205500.0,
               lowestPrice: 205000.0,
               highestPrice: 211000.0,
               closePrice: 206000.0)
    ]
}

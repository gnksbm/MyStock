//
//  CandlestickChartView.swift
//  DesignSystem
//
//  Created by gnksbm on 5/3/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core

public final class CandlestickChartView: UIScrollView {
    private var dataSource: [CandlestickRepresentable] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var visibleViewDic = [Date: (body: UIView, tail: UIView)]()
    
    public var appearance = Appearance()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = appearance.backgroundColor
    }
    
    public init() {
        super.init(frame: .zero)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateChart(dataSource: [CandlestickRepresentable]) {
        let sortedDataSource = dataSource.sorted { $0.date < $1.date }
        self.dataSource = sortedDataSource
        let contentWidth = CGFloat(dataSource.count) * appearance.candleWidth
        contentSize = CGSize(width: contentWidth, height: bounds.height)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let chartHighest = dataSource.chartHighest,
              let chartLowest = dataSource.chartLowest
        else { return }
        
        let candleWidth = contentSize.width / dataSource.count.f
        let chartRange = (chartHighest - chartLowest) / contentSize.height
        
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let startIndex = max(Int(visibleRect.minX / candleWidth), 0)
        let endIndex = min(
            Int((visibleRect.maxX + candleWidth) / candleWidth),
            dataSource.count
        )
        
        for index in startIndex..<endIndex {
            drawCandle(
                index: index,
                chartRange: chartRange,
                candleWidth: candleWidth,
                chartHighest: chartHighest
            )
        }
    }
    
    private func drawCandle(
        index: Int,
        chartRange: CGFloat,
        candleWidth: CGFloat,
        chartHighest: CGFloat
    ) {
        let candle = dataSource[index]
        if let visibleCandle = visibleViewDic[candle.date] {
            let candleHeight
            = candle.dailyRange == 0 ? 1 : candle.dailyRange / chartRange
            if visibleCandle.body.bounds.height != candleHeight {
                visibleViewDic.removeValue(
                    forKey: candle.date
                )
                visibleCandle.body.removeFromSuperview()
                visibleCandle.tail.removeFromSuperview()
            } else {
                return
            }
        }
        
        let bodyHeight
        = candle.fluctuation == 0 ? 1 : candle.fluctuation / chartRange
        let tailHeight
        = candle.dailyRange == 0 ? 1 : candle.dailyRange / chartRange
        
        let bodyRect = CGRect(
            x: CGFloat(index) * candleWidth
            + (appearance.bodyWidthMultiplier / 2),
            y: (chartHighest - candle.openingPrice) / chartRange,
            width: candleWidth * appearance.bodyWidthMultiplier,
            height: bodyHeight
        )
        
        let tailRect = CGRect(
            x: bodyRect.minX + (bodyRect.width / 2),
            y: (chartHighest - candle.highestPrice) / chartRange,
            width: appearance.tailWidth,
            height: tailHeight
        )
        
        let candleBodyView = UIView()
        let candleTailView = UIView()
        
        [candleBodyView, candleTailView].forEach {
            $0.backgroundColor = getCandleColor(kind: candle.candleKind)
            addSubview($0)
        }
        
        visibleViewDic[candle.date] = (candleBodyView, candleTailView)
        
        candleBodyView.frame = bodyRect
        candleTailView.frame = tailRect
    }
    
    private func getCandleColor(kind: CandleKind) -> UIColor {
        var candleColor: UIColor
        switch kind {
        case .white:
            candleColor = appearance.whiteCandleColor
        case .dodge:
            candleColor = appearance.dodgeCandleColor
        case .black:
            candleColor = appearance.blackCandleColor
        }
        return candleColor
    }
}

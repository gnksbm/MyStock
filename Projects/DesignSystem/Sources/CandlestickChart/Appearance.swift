//
//  BarAppearance.swift
//  DesignSystem
//
//  Created by gnksbm on 5/3/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

extension CandlestickChartView {
    public struct Appearance {
        let tailWidth: CGFloat
        let bodyWidthMultiplier: CGFloat
        let candleWidth: CGFloat
        let whiteCandleColor: UIColor
        let dodgeCandleColor: UIColor
        let blackCandleColor: UIColor
        let backgroundColor: UIColor
        
        public init(
            tailWidth: CGFloat = 1,
            bodyWidthMultiplier: CGFloat = 0.9,
            candleWidth: CGFloat = 10,
            whiteCandleColor: UIColor = .red,
            dodgeCandleColor: UIColor = .gray,
            blackCandleColor: UIColor = .blue,
            backgroundColor: UIColor = .systemBackground
        ) {
            self.tailWidth = tailWidth
            self.bodyWidthMultiplier = bodyWidthMultiplier
            self.candleWidth = candleWidth
            self.whiteCandleColor = whiteCandleColor
            self.dodgeCandleColor = dodgeCandleColor
            self.blackCandleColor = blackCandleColor
            self.backgroundColor = backgroundColor
        }
    }
}

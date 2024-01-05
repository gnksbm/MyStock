//
//  CandleChartCV.swift
//  DesignSystem
//
//  Created by gnksbm on 2024/01/02.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

public final class CandleChartCV: UICollectionView {
    private var candles: [Candle] = []
    
    public override init(
        frame: CGRect,
        collectionViewLayout: UICollectionViewLayout
    ) {
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = DesignSystemAsset.chartBackground.color
        dataSource = self
        register(
            CandleChartCVCell.self,
            forCellWithReuseIdentifier: CandleChartCVCell.identifier
        )
    }
    
    public func updateCandles(_ candles: [Candle]) {
        var difference = false
        if self.candles != candles,
           !self.candles.isEmpty {
            difference = true
        }
        self.candles = candles
        if difference {
            reloadItems(at: [.init(row: candles.count-1, section: 0)])
            return
        }
        reloadData()
    }
}

extension CandleChartCV: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        candles.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CandleChartCVCell.identifier,
            for: indexPath
        ) as? CandleChartCVCell else { return UICollectionViewCell()}
        let highestPrice = candles.highestPrice
        let lowestPrice = candles.lowestPrice
        let shape = CandleShape(
            viewHeight: self.bounds.height,
            viewWidth: self.bounds.width,
            highestPrice: highestPrice,
            lowestPrice: lowestPrice,
            totalCandleCount: candles.count.f,
            candle: candles.sorted(by: { $0.date < $1.date })[indexPath.row]
        )
        cell.drawCandle(shape: shape)
        return cell
    }
}

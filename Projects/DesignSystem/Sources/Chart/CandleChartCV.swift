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
    
    public init() {
        super.init(
            frame: .zero,
            collectionViewLayout: .init()
        )
        configure()
    }
    
    private var minCellSize: CGFloat = 20
    
    private var itemCount: CGFloat {
        CGFloat.screenWidth / candles.count.f < minCellSize ?
        CGFloat.screenWidth / minCellSize :
        candles.count.f
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = DesignSystemAsset.chartBackground.color
        dataSource = self
        isScrollEnabled = CGFloat.screenWidth / candles.count.f < minCellSize
        register(
            CandleChartCVCell.self,
            forCellWithReuseIdentifier: CandleChartCVCell.identifier
        )
    }
    
    private func checkStatus(candles: [Candle]) -> CandleStatus {
        var status = CandleStatus.empty
        if self.candles.isEmpty, !candles.isEmpty {
            status = .firstFetch
        } else if self.candles != candles {
            status = .notDiff
        } else if self.candles == candles {
            status = .diff
        }
        return status
    }
    
    public func updateCandles(_ candles: [Candle]) {
        let status = checkStatus(candles: candles)
        self.candles = candles
        switch status {
        case .empty:
            break
        case .firstFetch:
            setCollectionViewLayout(
                updateLayout(),
                animated: true
            )
            reloadData()
            scrollToItem(
                at: IndexPath(row: candles.count-1, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        case .diff:
            UIView.performWithoutAnimation {
                //                let offset = contentOffset
                reloadItems(at: [.init(row: candles.count-1, section: 0)])
                //                setContentOffset(offset, animated: false)
            }
        case .notDiff:
            break
        }
    }
    
    func updateLayout() -> UICollectionViewCompositionalLayout {
        .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / self.itemCount),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
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
            totalCandleCount: itemCount,
            candle: candles.sorted(by: { $0.date < $1.date })[indexPath.row]
        )
        cell.drawCandle(shape: shape)
        return cell
    }
}

extension CandleChartCV {
    enum CandleStatus {
        case empty, firstFetch, diff, notDiff
    }
}

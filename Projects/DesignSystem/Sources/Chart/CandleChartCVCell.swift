//
//  CandleChartCVCell.swift
//  DesignSystem
//
//  Created by gnksbm on 2024/01/02.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class CandleChartCVCell: UICollectionViewCell {
    let candleTailView = UIView()
    let candleBodyView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        candleTailView.frame = .zero
        candleBodyView.frame = .zero
    }
    
    private func configureUI() {
        [candleTailView, candleBodyView].forEach {
            contentView.addSubview($0)
        }
        candleBodyView.layer.cornerRadius = 2
    }
    
    public func drawCandle(
        dayTop: CGFloat,
        dayLow: CGFloat,
        dayOpen: CGFloat,
        dayClose: CGFloat,
        visibleTop: CGFloat,
        visibleLow: CGFloat
    ) {
        let visibleRange = visibleTop - visibleLow
        let tailHeightRatio = (dayTop - dayLow) / visibleRange
        let tailBodyRatio = (visibleTop - dayTop) / visibleRange
        let bodyHeightRatio = (dayOpen - dayClose) / visibleRange
        let bodyBodyRatio = (visibleTop - dayClose) / visibleRange
        [candleTailView, candleBodyView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            candleTailView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: tailHeightRatio // (현재 최고가 - 현재 최저가) / (전체 최고가 - 전체 최저가)
            ),
            candleTailView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: tailBodyRatio // (전체 최고가 - 종가) / (전체 최고가 - 전체 최저가)
            ),
            candleTailView.widthAnchor.constraint(
                equalToConstant: 1
            ),
            candleTailView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            
            candleBodyView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: bodyHeightRatio // (시가 - 종가) / (전체 최고가 - 전체 최저가)
            ),
            candleBodyView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: bodyBodyRatio // (전체 최고가 - 종가) / (전체 최고가 - 전체 최저가)
            ),
            candleBodyView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 0.9
            ),
            candleBodyView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
        ])
        contentView.layoutIfNeeded()
    }
    public func drawCandle(shape: CandleShape) {
        [candleTailView, candleBodyView].forEach {
            $0.backgroundColor = shape.candleColor
        }
    
        candleTailView.frame = shape.getFrame(.tail)
        candleBodyView.frame = shape.getFrame(.body)
    }
}

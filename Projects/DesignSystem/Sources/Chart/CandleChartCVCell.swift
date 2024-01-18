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
    
    public func drawCandle(shape: CandleShape) {
        [candleTailView, candleBodyView].forEach {
            $0.backgroundColor = shape.candleColor
        }
        
        candleTailView.frame = shape.getFrame(.tail)
        candleBodyView.frame = shape.getFrame(.body)
    }
}

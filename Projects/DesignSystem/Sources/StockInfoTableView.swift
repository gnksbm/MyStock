//
//  StockInfoTableView.swift
//  DesignSystem
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public final class StockInfoTableView: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        register(
            StockInfoTVCell.self,
            forCellReuseIdentifier: StockInfoTVCell.identifier
        )
        backgroundColor = DesignSystemAsset.chartBackground.color
        separatorColor = DesignSystemAsset.chartForeground.color
    }
}

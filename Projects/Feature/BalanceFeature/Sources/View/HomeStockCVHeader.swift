//
//  HomeStockCVHeader.swift
//  BalanceFeature
//
//  Created by gnksbm on 2/24/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem

final class HomeStockCVHeader: UICollectionReusableView {
    private let ratioDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: UIFont.labelFontSize,
            weight: .bold
        )
        label.textColor = DesignSystemAsset.accentColor.color
        label.text = "담보 유지 비율"
        return label
    }()
    
    private let ratioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: UIFont.labelFontSize,
            weight: .bold
        )
        label.textColor = DesignSystemAsset.accentColor.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateUI(ratio: "")
    }
    
    private func configureUI() {
        [ratioDescriptionLabel, ratioLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            ratioDescriptionLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            
            ratioLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
        ])
    }
    
    func updateUI(ratio: String) {
        ratioLabel.text = ratio
    }
}

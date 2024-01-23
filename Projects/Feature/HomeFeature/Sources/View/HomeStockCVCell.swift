//
//  HomeStockCVCell.swift
//  HomeFeature
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain
import DesignSystem

final class HomeStockCVCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        priceLabel.text = ""
        let foregroundColor = DesignSystemAsset.chartForeground.color
        contentView.layer.borderColor = foregroundColor.cgColor
        titleLabel.textColor = foregroundColor
        priceLabel.textColor = foregroundColor
    }
    
    func prepare(item: KISCheckBalanceResponse) {
        titleLabel.text = item.name
        priceLabel.text = item.price
        guard let rate = Double(item.fluctuationRate) else { return }
        var color: UIColor
        let foregroundColor = DesignSystemAsset.chartForeground.color
        if rate == 0 {
            color = foregroundColor
        } else if rate > 0 {
            color = DesignSystemAsset.profit.color
        } else {
            color = DesignSystemAsset.loss.color
        }
        titleLabel.textColor = color
        priceLabel.textColor = color
        contentView.layer.borderColor = color.cgColor
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
        [titleLabel, priceLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.centerYAnchor,
                constant: -5
            ),
            
            priceLabel.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            priceLabel.topAnchor.constraint(
                equalTo: contentView.centerYAnchor,
                constant: 5
            ),
        ])
    }
}

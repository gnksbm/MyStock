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
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let fluctuationRateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
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
        let foregroundColor = DesignSystemAsset.chartForeground.color
        contentView.layer.borderColor = foregroundColor.cgColor
        [
            titleLabel,
            priceLabel,
            fluctuationRateLabel,
            amountLabel,
        ].forEach {
            $0.text = ""
            $0.textColor = foregroundColor
        }
    }
    
    func updateUI(item: KISCheckBalanceResponse) {
        titleLabel.text = item.name
        priceLabel.text = item.price
        amountLabel.text = "\(item.amount)주"
        fluctuationRateLabel.text = "\(item.fluctuationRate)"
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
        [
            titleLabel,
            priceLabel,
            amountLabel,
            fluctuationRateLabel,
        ].forEach {
            $0.textColor = color
        }
        contentView.layer.borderColor = color.cgColor
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
        [
            titleLabel,
            priceLabel,
            amountLabel,
            fluctuationRateLabel,
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            
            priceLabel.topAnchor.constraint(
                equalTo: titleLabel.topAnchor
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 20
            ),
            
            fluctuationRateLabel.topAnchor.constraint(
                equalTo: titleLabel.topAnchor
            ),
            fluctuationRateLabel.leadingAnchor.constraint(
                equalTo: priceLabel.trailingAnchor,
                constant: 20
            ),
            
            amountLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            amountLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
        ])
    }
}

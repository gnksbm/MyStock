//
//  TopVolumeCVCell.swift
//  SummaryFeature
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem
import Domain
import FeatureDependency

import SnapKit

final class TopVolumeCVCell: BaseCVCell, RegistrableCellType {
    static func makeRegistration() -> Registration<KISTopVolumeResponse> {
        Registration { cell, indexPath, item in
            cell.rankLabel.text = item.rank
            cell.iconImageView.image = item.image
            cell.nameLabel.text = item.name
            cell.tickerLabel.text = item.ticker
            cell.priceLabel.text = item.price
            cell.rateLabel.text = item.fluctuationRate
            cell.rateLabel.textColor = item.fluctuationRate.toColorForNumeric
        }
    }
    
    private let rankLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let iconImageView = UIImageView()
    private let nameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let tickerLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    private let rateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .right
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [
            rankLabel,
            nameLabel,
            tickerLabel,
            priceLabel,
            rateLabel
        ].forEach { $0.text = nil }
        iconImageView.image = nil
    }
    
    override func configureLayout() {
        [
            rankLabel,
            iconImageView,
            nameLabel,
            tickerLabel,
            priceLabel,
            rateLabel
        ].forEach { contentView.addSubview($0) }
        
        let padding = 20.f
        
        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(padding)
            make.centerY.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(padding)
            make.size.equalTo(contentView.snp.height).multipliedBy(0.5)
            make.centerY.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(padding)
            make.top.equalTo(contentView).inset(padding)
        }
        
        tickerLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(contentView).inset(padding)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing)
                .offset(padding)
            make.top.trailing.equalTo(contentView).inset(padding)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom)
            make.bottom.equalTo(tickerLabel)
        }
    }
}

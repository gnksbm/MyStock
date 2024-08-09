//
//  FavoriteCVCell.swift
//  FavoritesFeature
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem
import Domain
import FeatureDependency

import SnapKit

final class FavoriteCVCell: BaseCVCell, RegistrableCellType {
    static func makeRegistration() -> Registration<KISCurrentPriceResponse> {
        Registration { cell, _, item in
            cell.iconImageView.image = item.image
            cell.nameLabel.text = item.name
            cell.tickerLabel.text = item.ticker
            cell.priceLabel.text = item.price.toCurrency(style: .currency)
            cell.rateLabel.text = item.fluctuationRate.toPercent()
            cell.rateLabel.textColor =
            item.fluctuationRate.toColorForNumeric
        }
    }
    
    private let iconImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = DesignSystemAsset.accentColor.color
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = DesignSystemAsset.Radius.logoImage
        return imageView
    }()
    private let nameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let tickerLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
        return label
    }()
    private let rateLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textAlignment = .right
        return label
    }()
    
    override func configureLayout() {
        [
            iconImageView,
            nameLabel,
            tickerLabel,
            priceLabel,
            rateLabel
        ].forEach { contentView.addSubview($0) }
        
        let padding = DesignSystemAsset.Padding.regular
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(padding)
            make.height.equalTo(DesignSystemAsset.Demension.logoImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(padding)
            make.leading.equalTo(iconImageView.snp.trailing).offset(padding)
            make.bottom.equalTo(iconImageView.snp.centerY)
        }
        
        tickerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(padding / 2)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(padding)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(padding)
            make.trailing.equalTo(rateLabel)
            make.bottom.equalTo(rateLabel.snp.top)
        }
    }
}

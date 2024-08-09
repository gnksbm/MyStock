//
//  TopRankCVCell.swift
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

final class TopRankCVCell: BaseCVCell, RegistrableCellType {
    static func makeRegistration() -> Registration<KISTopRankResponse> {
        Registration { cell, _, item in
            cell.rankLabel.text = item.rank
            cell.iconImageView.image = item.image
            cell.nameLabel.text = item.name
            cell.tickerLabel.text = item.ticker
            cell.priceLabel.text = item.price.toCurrency(style: .currency)
            cell.rateLabel.text = item.fluctuationRate.toPercent()
            cell.rateLabel.textColor =
            item.fluctuationRate.toColorForNumeric
        }
    }
    
    private let rankLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
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
    private let dividerView = {
        let label = UIView()
        label.backgroundColor = DesignSystemAsset.accentColor.color
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
    
    override func configureUI() {
        contentView.backgroundColor = DesignSystemAsset.chartBackground.color
    }
    
    override func configureLayout() {
        [
            rankLabel,
            iconImageView,
            nameLabel,
            tickerLabel,
            priceLabel,
            rateLabel,
            dividerView
        ].forEach { contentView.addSubview($0) }
        
        let padding = 20.f
        
        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(padding / 2)
            make.centerY.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.1)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(padding / 3)
            make.size.equalTo(DesignSystemAsset.Demension.logoImage)
            make.centerY.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(padding)
            make.top.equalTo(contentView).inset(padding).priority(.required)
        }
        
        tickerLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).priority(.required)
            make.bottom.equalTo(contentView).inset(padding).priority(.required)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(padding)
            make.top.trailing.equalTo(contentView).inset(padding)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(padding)
            make.top.equalTo(priceLabel.snp.bottom)
            make.bottom.equalTo(tickerLabel)
        }
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalTo(contentView)
        }
    }
}

//
//  FavoriteCVCell.swift
//  FavoritesFeature
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import Domain

import SnapKit
import RxSwift

public final class FavoriteCVCell: BaseCVCell, RegistrableCellType {
    public static func makeRegistration(
    ) -> Registration<KISCurrentPriceResponse> {
        Registration { cell, _, item in
            cell.iconImageView.image = item.image
            cell.nameLabel.text = item.name
            cell.tickerLabel.text = item.ticker
            cell.priceLabel.text = item.price.formatted(style: .currency)
            cell.rateLabel.text = item.fluctuationRate.toPercent()
            cell.rateLabel.textColor =
            item.fluctuationRate.toForegroundColorForNumeric
            cell.rateLabel.backgroundColor =
            item.fluctuationRate.toBackgroundColorForNumeric
        }
    }
    
    public var disposeBag = DisposeBag()
    
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
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    private let rateLabel = {
        let label = PaddingLabel(
            inset: UIEdgeInsets(
                top: 2,
                left: 4,
                bottom: 2,
                right: 4
            )
        )
        label.font = .boldSystemFont(ofSize: 11)
        label.textAlignment = .right
        label.clipsToBounds = true
        label.layer.cornerRadius = DesignSystemAsset.Radius.small
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        iconImageView.image = nil
        [
            nameLabel,
            tickerLabel,
            priceLabel
        ].forEach { $0.text = nil }
        rateLabel.text = nil
    }
    
    public override func configureUI() {
        clipsToBounds = true
        layer.cornerRadius = DesignSystemAsset.Radius.medium
        layer.borderWidth = 1
        layer.borderColor = DesignSystemAsset.accentColor.color.cgColor
    }
    
    public override func configureLayout() {
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
            make.size.equalTo(DesignSystemAsset.Demension.logoImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(padding)
            make.leading.equalTo(iconImageView.snp.trailing).offset(padding / 2)
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

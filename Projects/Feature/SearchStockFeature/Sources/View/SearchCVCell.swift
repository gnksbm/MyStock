//
//  SearchCVCell.swift
//  SearchStockFeature
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxSwift
import SnapKit

final class SearchCVCell: BaseCVCell, RegistrableCellType {
    static func makeRegistration() -> Registration<SearchStocksResponse> {
        Registration { cell, _, item in
            cell.logoImageView.image = item.image
            cell.nameLabel.text = item.name
            cell.tickerLabel.text = item.ticker
            cell.starButton.setImage(
                UIImage(systemName: item.isLiked ? "star.fill" : "star"),
                for: .normal
            )
        }
    }
    
    var disposeBag = DisposeBag()
    
    private let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = DesignSystemAsset.Radius.logoImage
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = DesignSystemAsset.lightBlack.color
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    let starButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "star")
        button.configuration?.baseForegroundColor =
        DesignSystemAsset.whiteCandle.color
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        logoImageView.image = nil
        [nameLabel, tickerLabel].forEach { $0.text = nil }
    }
    
    override func configureLayout() {
        [logoImageView, tickerLabel, nameLabel, starButton].forEach {
            contentView.addSubview($0)
        }
        
        let padding = 20.f
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(padding)
            make.centerY.equalTo(contentView)
            make.size.equalTo(DesignSystemAsset.Demension.logoImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(padding)
            make.leading.equalTo(logoImageView.snp.trailing).offset(padding)
        }
        
        tickerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(padding / 2)
            make.bottom.equalTo(contentView).inset(padding)
        }
        
        starButton.snp.makeConstraints { make in
            make.size.equalTo(logoImageView).multipliedBy(0.5)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(tickerLabel.snp.trailing).offset(padding)
            make.trailing.equalTo(contentView).inset(padding)
        }
    }
}

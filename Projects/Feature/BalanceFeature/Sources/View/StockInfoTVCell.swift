//
//  StockInfoTVCell.swift
//  BalanceFeature
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain
import DesignSystem

import RxSwift
import SnapKit

final class StockInfoTVCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    private let imgViewSize = 40.f
    
    private lazy var logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = imgViewSize / 2
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let plAmoutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let foregroundColor = DesignSystemAsset.chartForeground.color
        logoImgView.image = nil
        [
            valueLabel,
            titleLabel,
            priceLabel,
            plAmoutLabel,
            amountLabel,
        ].forEach {
            $0.text = nil
            $0.textColor = foregroundColor
        }
        disposeBag = .init()
    }
    
    func updateUI(item: KISCheckBalanceResponse) {
        logoImgView.image = item.image?.resized(
            to: .init(
                width: imgViewSize,
                height: imgViewSize
            )
        )
        let amountMutableString = NSMutableAttributedString()
        let amountText = NSAttributedString(
            string: "\(item.amount)주",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        amountMutableString.append(amountText)
        if item.division == .loan {
            amountMutableString.append(
                .init(
                    string: " 신용",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14),
                        .foregroundColor: DesignSystemAsset.whiteCandle.color
                    ]
                )
            )
        }
        titleLabel.text = item.name
        amountLabel.attributedText = amountMutableString
        valueLabel.text = item.value.toCurrency(style: .decimal) + "원"
        plAmoutLabel.text
        = item.plAmount.toCurrency(style: .decimal) + "원"
        var priceText = item.price.toCurrency(style: .decimal) + "원"
        let fluctuationRate = "\(item.rateToDoubleDigits) %"
        guard let rate = Double(item.fluctuationRate) else { return }
        switch rate {
        case ..<0:
            priceText += "(\(fluctuationRate))"
        case 0:
            priceText +=  "(\(fluctuationRate))"
        default:
            priceText +=  "(+\(fluctuationRate))"
        }
        priceLabel.text = priceText
        plAmoutLabel.textColor = item.plAmount.toForegroundColorForNumeric
        priceLabel.textColor = item.fluctuationRate.toForegroundColorForNumeric
    }
    
    private func configureUI() {
        contentView.backgroundColor = DesignSystemAsset.chartBackground.color
        
        [
            valueLabel,
            logoImgView,
            titleLabel,
            priceLabel,
            amountLabel,
            plAmoutLabel,
        ].forEach {
            contentView.addSubview($0)
        }
        
        logoImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(imgViewSize)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(logoImgView.snp.trailing).offset(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        plAmoutLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel)
            make.trailing.equalTo(valueLabel)
        }
    }
}

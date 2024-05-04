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
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let plAmoutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
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
            string: item.amount,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        amountMutableString.append(amountText)
        if item.division == .loan {
            amountMutableString.append(
                .init(
                    string: " 신용",
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 16),
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
        var priceText = item.price
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
        plAmoutLabel.textColor = item.plAmount.toColorForNumeric
        priceLabel.textColor = item.fluctuationRate.toColorForNumeric
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
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImgView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            logoImgView.heightAnchor.constraint(
                equalToConstant: imgViewSize
            ),
            logoImgView.widthAnchor.constraint(
                equalTo: logoImgView.heightAnchor
            ),
            logoImgView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: logoImgView.trailingAnchor,
                constant: 20
            ),
            
            amountLabel.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            amountLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 5
            ),
            
            priceLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 5
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            priceLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            
            valueLabel.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            valueLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
            
            plAmoutLabel.bottomAnchor.constraint(
                equalTo: priceLabel.bottomAnchor
            ),
            plAmoutLabel.trailingAnchor.constraint(
                equalTo: valueLabel.trailingAnchor
            ),
        ])
    }
}

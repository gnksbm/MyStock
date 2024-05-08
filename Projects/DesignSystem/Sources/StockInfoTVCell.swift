//
//  StockInfoTVCell.swift
//  DesignSystem
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import RxSwift

public final class StockInfoTVCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    private let imgViewSize = 40.f
    
    private lazy var logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = imgViewSize / 2
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = DesignSystemAsset.lightBlack.color
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemAsset.chartForeground.color
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        logoImgView.image = nil
        [tickerLabel, nameLabel].forEach {
            $0.text = nil
        }
        disposeBag = .init()
    }
    
    public func updateUI(
        image: UIImage?,
        ticker: String,
        name: String
    ) {
        logoImgView.image = image?.resized(
            to: .init(
                width: imgViewSize,
                height: imgViewSize
            )
        )
        tickerLabel.text = ticker
        nameLabel.text = name
    }
    
    private func configureUI() {
        selectionStyle = .none
        contentView.backgroundColor = DesignSystemAsset.chartBackground.color
        
        [logoImgView, tickerLabel, nameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                .isActive = true
        }
        
        NSLayoutConstraint.activate([
            logoImgView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            logoImgView.heightAnchor.constraint(
                equalToConstant: imgViewSize
            ),
            logoImgView.widthAnchor.constraint(
                equalTo: logoImgView.heightAnchor
            ),
            
            tickerLabel.leadingAnchor.constraint(
                equalTo: logoImgView.trailingAnchor,
                constant: 20
            ),
            tickerLabel.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 1 / 4
            ),
            
            nameLabel.leadingAnchor.constraint(
                equalTo: tickerLabel.trailingAnchor,
                constant: 20
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
        ])
    }
}

//
//  StockInfoTVCell.swift
//  DesignSystem
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public final class StockInfoTVCell: UITableViewCell {
    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
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
        tickerLabel.text = ""
        nameLabel.text = ""
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    public func updateUI(ticker: String, name: String) {
        tickerLabel.text = ticker
        nameLabel.text = name
    }
    
    private func configureUI() {
        let foregroundColor = DesignSystemAsset.chartForeground.color
        contentView.layer.borderColor = foregroundColor.cgColor
        contentView.backgroundColor = DesignSystemAsset.chartBackground.color
        
        [tickerLabel, nameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tickerLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            tickerLabel.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 1/4
            ),
            tickerLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            
            nameLabel.leadingAnchor.constraint(
                equalTo: tickerLabel.trailingAnchor,
                constant: 10
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            nameLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
        ])
    }
}

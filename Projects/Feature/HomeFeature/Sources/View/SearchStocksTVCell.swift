//
//  SearchStocksTVCell.swift
//  HomeFeature
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Domain

final class SearchStocksTVCell: UITableViewCell {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: .init(top: 5, left: 5, bottom: 5, right: 5)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tickerLabel.text = ""
        nameLabel.text = ""
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func prepare(response: KISSearchStocksResponse) {
        tickerLabel.text = response.ticker
        nameLabel.text = response.name
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
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
